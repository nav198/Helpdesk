//
//  AssetCategoryResponse.swift
//  Ed
//
//  Created by Beera Naveen on 02/06/25.
//

import Foundation

struct AssetCategoryResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let data: [DataResponse]
}

// MARK: - Datum
struct DataResponse: Codable {
    let id: Int
    let name: String
    let projectID: Int
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case projectID = "project_id"
        case description
    }
}
