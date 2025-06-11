//
//  AssetCategory.swift
//  Ed
//
//  Created by Beera Naveen on 02/06/25.
//

import Foundation

struct AssetCategoryIssueResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let data: [AssetIssueResponse]
}

struct AssetIssueResponse: Codable {
    let id: Int
    let name, description: String
    let assetItemCategory: AssetItemCategory
    let issueType: IssueType
    let projectID: Int

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case assetItemCategory = "asset_item_category"
        case issueType = "issue_type"
        case projectID = "project_id"
    }
}

struct AssetItemCategory: Codable {
    let id: Int
    let name: String
}

enum IssueType: String, Codable {
    case hardware = "hardware"
    case software = "software"
}
