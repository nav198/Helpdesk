//
//  APIConstants.swift
//  Ed
//
//  Created by Beera Naveen on 28/05/25.
//

import Foundation

enum API {
    static let baseURL = URL(string: "https://jh-apis.edcloud.in/api/v1")!
    
    enum Endpoint {
        case devicesList(projectID: Int)
        case userProfile(userID: Int)
        case userLogin
        case requestForService
        case refreshToken
        case serviceHistory(projectID: Int)
        case assetCategory(projectID: Int)
        case assetIssueType(projectID:Int,category_id: Int,issue_type:String)
       
        func url() -> URL {
            switch self {
            case .devicesList(let projectID):
                var components = URLComponents(url: API.baseURL.appendingPathComponent("asset"), resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "project_id", value: "\(projectID)")
                ]
                return components.url!
            case .userProfile(let userID):
                return API.baseURL.appendingPathComponent("user/profile/\(userID)")
            case .userLogin:
                return API.baseURL.appendingPathComponent("user/login")
            case .requestForService:
                return API.baseURL.appendingPathComponent("service-desk")
            case .refreshToken:
                   return API.baseURL.appendingPathComponent("user/refresh")
            case .serviceHistory(projectID: let projectID):
                var components = URLComponents(url: API.baseURL.appendingPathComponent("service-desk"), resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "project_id", value: "\(projectID)")
                ]
                return components.url!
            case .assetCategory(projectID: let projectID):
                var components = URLComponents(url: API.baseURL.appendingPathComponent("config/asset-item-category"), resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "project_id", value: "\(projectID)")
                ]
                return components.url!
           
            case .assetIssueType(projectID: let projectID,category_id: let category_id, issue_type: let issue_type):
                var components = URLComponents(url: API.baseURL.appendingPathComponent("config/asset-item-category-issue"), resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "project_id", value: "\(projectID)"),
                    URLQueryItem(name: "asset_item_category_id", value: "\(category_id)"),
                    URLQueryItem(name: "issue_type", value: issue_type)
                ]
                return components.url!
            }
        }
    }
}
