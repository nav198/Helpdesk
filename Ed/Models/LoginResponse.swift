//
//  UserData.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation

struct LoginDataResponse:Codable{
    var success:Bool
    var status:Int
    var message:String
    var data:User
}

struct User:Codable{
    var id:Int
    var email:String
    var first_name:String
    var last_name:String
    var date_of_joining:String
    var state:String
    var district:String
    var contact_number:String
    var access_token:String
    var refresh_token:String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}
