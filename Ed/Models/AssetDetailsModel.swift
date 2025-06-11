//
//  AssetDetails.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation

// The root object returned from the API
struct AssetDetails: Codable {
    let success: Bool?
    let status: Int?
    let message: String?
    let data: [Results]?
}

struct Results: Codable {
    let id: Int?
    let projectID: Int?
    let itemCategory: String?
    let itemMake: String?
    let itemSerialNo: String?
    let itemModelName: String?
    let serviceSlaAmount: Int?
    let serviceSlaDays: Int?
    let warrantyStartDate: String?
    let backdatedDate: String?
    let warrantyEndDate: String?
    let description: String?
    let status: String?
    let instituteType: String?
    let labSubType: String?
    let labNumber: Int?
    let penalityPerDay: Int?
    let itemReplacedBySerialNo: String? 
    let assetServiceProvider: AssetServiceProvider?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case itemCategory = "item_category"
        case itemMake = "item_make"
        case itemSerialNo = "item_serial_no"
        case itemModelName = "item_model_name"
        case serviceSlaAmount = "service_sla_amount"
        case serviceSlaDays = "service_sla_days"
        case warrantyStartDate = "warranty_start_date"
        case backdatedDate = "backdated_date"
        case warrantyEndDate = "warranty_end_date"
        case description, status
        case instituteType = "institute_type"
        case labSubType = "lab_sub_type"
        case labNumber = "lab_number"
        case penalityPerDay = "penality_per_day"
        case itemReplacedBySerialNo = "item_replaced_by_serial_no"
        case assetServiceProvider = "asset_service_provider"
    }
}

// The asset service provider info
struct AssetServiceProvider: Codable {
    let id: Int?
    let providerName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case providerName = "provider_name"
    }
}
