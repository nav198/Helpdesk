//
//  NetworkError.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation

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
