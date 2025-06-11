//
//  LogoutManager.swift
//  Ed
//
//  Created by Beera Naveen on 28/05/25.
//

import Foundation

final class LogoutManager {
    static func performLogout() {
        // Clear Keychain tokens
        KeychainHelper.shared.delete(key: "accessToken")
        KeychainHelper.shared.delete(key: "refreshToken")

        // Clear user defaults if needed
        UserDefaults.standard.removeObject(forKey: "userId")

        // Update isLoggedIn AppStorage (triggers splash/login logic)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")

        // Optionally reset other app-wide state here
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didLogout, object: nil)
        }
    }
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}
