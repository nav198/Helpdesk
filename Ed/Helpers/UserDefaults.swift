//
//  UserDefaults.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 13/05/25.
//

import Foundation
import UIKit

struct StorageKey {
    static let deviceToken = "deviceToken"
    static let sessionId = "sessionId"
    static let subscriptionId = "subscriptionId"
    static let accessToken = "accessToken"
    static let userType = "userType"
    static let userName = "userName"
    static let region = "region"
    static let accountId = "accountID"
    static let devNodeUrl = "devNodeUrl"
    static let refreshToken = "refreshToken"
    static let isProdURL = "isProdURL"
}


class UserDefaultsManager{
    static let shared = UserDefaultsManager()
    
    private init(){}
    
    func setToken(devicetoken: String) {
        let userDefualt = UserDefaults.standard
        userDefualt.set(devicetoken, forKey: StorageKey.deviceToken);
        userDefualt.synchronize()
    }
    func getToken() -> String? {
        let userDefualt = UserDefaults.standard;
        return userDefualt.string(forKey: StorageKey.deviceToken)
    }
    
}
