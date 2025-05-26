//
//  Webservice.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation
import Foundation

enum API {
    static let baseURL = URL(string: "http://13.203.78.74:3000/api/v1")!
    
    enum Endpoint {
        case devicesList(projectID: Int)
        case userProfile(userID: Int)
        case userLogin
        case refreshToken
        case serviceHistory(projectID: Int)
        
        func url() -> URL {
            switch self {
            case .devicesList(let projectID):
                var components = URLComponents(url: API.baseURL.appendingPathComponent("asset"), resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "project_id", value: "\(projectID)")
                ]
                
                print("components.url! \(components.url!)")
                return components.url!
            case .userProfile(let userID):
                return API.baseURL.appendingPathComponent("user/profile/\(userID)")
            case .userLogin:
                return API.baseURL.appendingPathComponent("user/login")
            case .refreshToken:
                   return API.baseURL.appendingPathComponent("user/refresh")
            case .serviceHistory(projectID: let projectID):
                var components = URLComponents(url: API.baseURL.appendingPathComponent("service-desk"), resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "project_id", value: "\(projectID)")
                ]
                
                print("components.url! \(components.url!)")
                return components.url!
            }
        }
    }
}


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL is invalid."
        case .requestFailed: return "The request failed."
        case .invalidResponse: return "Invalid response from server."
        case .statusCode(let code): return "Unexpected status code: \(code)"
        case .decodingError: return "Failed to decode the response."
        case .unauthorized:
            return "Unauthorised access"
        }
    }
}

final class WebService {
    static let shared = WebService()
    private init() {}
    
    func fetchData<T: Decodable>(from url: URL) async -> Result<T, NetworkError> {
           return await performAuthorizedRequest(url: url, decodeTo: T.self, retryOnAuthFail: true)
       }

       private func performAuthorizedRequest<T: Decodable>(url: URL, decodeTo type: T.Type, retryOnAuthFail: Bool) async -> Result<T, NetworkError> {
           guard let token = KeychainHelper.shared.read(key: "accessToken") else {
               return .failure(.unauthorized)
           }

           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

           do {
               let (data, response) = try await URLSession.shared.data(for: request)

               guard let httpResponse = response as? HTTPURLResponse else {
                   return .failure(.invalidResponse)
               }

               if httpResponse.statusCode == 401 && retryOnAuthFail {
                   print("🔄 Token expired, attempting to refresh...")
                   let refreshResult = await refreshAccessToken()
                   switch refreshResult {
                   case .success:
                       // Retry original request
                       return await performAuthorizedRequest(url: url, decodeTo: type, retryOnAuthFail: false)
                   case .failure:
                       return .failure(.unauthorized)
                   }
               }

               guard (200..<300).contains(httpResponse.statusCode) else {
                   return .failure(.statusCode(httpResponse.statusCode))
               }

               let decoded = try JSONDecoder().decode(T.self, from: data)
               return .success(decoded)

           } catch {
               return .failure(.decodingError)
           }
       }
    
    
    func postData<T: Decodable, U: Encodable>(
            to url: URL,
            body: U,
            responseType: T.Type
        ) async -> Result<T, NetworkError> {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONEncoder().encode(body)
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    return .failure(.invalidResponse)
                }

                guard (200..<300).contains(httpResponse.statusCode) else {
                    print("Server returned status code: \(httpResponse.statusCode)")
                    return .failure(.statusCode(httpResponse.statusCode))
                }

                let decoded = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            } catch {
                print("Decoding error or network issue: \(error)")
                return .failure(.decodingError)
            }
        }
}


extension WebService {
    private func refreshAccessToken() async -> Result<Void, NetworkError> {
        guard let refreshToken = KeychainHelper.shared.read(key: "refreshToken") else {
            return .failure(.unauthorized)
        }

        var request = URLRequest(url: API.Endpoint.refreshToken.url())
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["refresh_token": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                return .failure(.statusCode(httpResponse.statusCode))
            }

            // Decode new tokens
            let tokenResponse = try JSONDecoder().decode(LoginDataResponse.self, from: data)

            // Save them
            KeychainHelper.shared.save(tokenResponse.data.access_token, key: "accessToken")
            KeychainHelper.shared.save(tokenResponse.data.refresh_token, key: "refreshToken")

            return .success(())

        } catch {
            return .failure(.decodingError)
        }
    }
}
