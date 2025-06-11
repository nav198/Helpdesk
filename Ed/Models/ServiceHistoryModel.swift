//
//  ServiceHistoryModel.swift
//  Ed
//
//  Created by Beera Naveen on 26/05/25.
//

import Foundation

struct ServiceHistoryResponse: Codable {
    var success: Bool
    var status: Int
    var message: String
    var data: [ServiceHistoryData]
}

struct ServiceHistoryData: Codable {
    var id: Int
    var project_id: Int
    var item_category: String   
    var problem_category: String
    var problem_sub_category: String
    var problem_description: String
    var ticket_complaint: String
    var status: String
    var open_date: String
    var close_date: String?
    var age: Int
    var asset: AssetDetailsResponse?
    var status_history: [StatusHistory]
    var complaint_by_user: String
    var institute: InstituteDetails?
}

struct StatusHistory: Codable {
    var remark: String
    var status: String
    var open_date: String
    var follow_up_date: String?
}

struct InstituteDetails: Codable {
    var id: Int
    var name: String
    var institute_code: String
    var udise_code: String
    var district: String
    var block: String
}


struct AssetDetailsResponse: Codable {
    let id, projectID, assetServiceProviderID: Int
    let itemCategory, itemMake, itemSerialNo, itemModelName: String
    let serviceSlaAmount, serviceSlaDays: Int
    let warrantyStartDate: String
//    let backdatedDate: JSONNull?
    let warrantyEndDate, description, status: String
    let instituteID: Int
    let labSubType: String
    let labNumber, penalityPerDay: Int
//    let itemReplacedBySerialNo: JSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case assetServiceProviderID = "asset_service_provider_id"
        case itemCategory = "item_category"
        case itemMake = "item_make"
        case itemSerialNo = "item_serial_no"
        case itemModelName = "item_model_name"
        case serviceSlaAmount = "service_sla_amount"
        case serviceSlaDays = "service_sla_days"
        case warrantyStartDate = "warranty_start_date"
//        case backdatedDate = "backdated_date"
        case warrantyEndDate = "warranty_end_date"
        case description, status
        case instituteID = "institute_id"
        case labSubType = "lab_sub_type"
        case labNumber = "lab_number"
        case penalityPerDay = "penality_per_day"
//        case itemReplacedBySerialNo = "item_replaced_by_serial_no"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
