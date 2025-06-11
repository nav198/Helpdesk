//
//  UserProfile.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation

struct UserProfile: Codable {
    var success: Bool
    var status: Int
    var message: String
    var data: UserProfileData
}

struct UserProfileData: Codable {
    var id: Int
    var first_name: String
    var last_name: String
    var email: String
    var contact_number: String
    var user_profile_image: String?
    var gender: String?            
}
