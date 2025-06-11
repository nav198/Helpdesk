//
//  ServiceRequest.swift
//  Ed
//
//  Created by Beera Naveen on 28/05/25.
//

import Foundation


struct ServiceRequestResponse: Codable {
    var project_id: Int
    var institute_id: Int
    var asset_id: Int
    var item_category: String
    var problem_category: String
    var problem_sub_category: String
    var problem_description: String
    var ticket_complaint: String
    var status: String
}
