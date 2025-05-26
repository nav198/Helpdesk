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
//    var asset: AssetDetails?
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
