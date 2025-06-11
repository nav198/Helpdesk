//
//  CustomAppDelegate.swift
//  Ediq
//
//  Created by Beera Naveen on 16/05/25.
//

import Foundation
import SwiftUI
import UserNotifications
//import GoogleSignIn
//import Firebase

class CustomAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    var app: Ed?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        application.registerForRemoteNotifications()
//        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("stringifiedToken:", stringifiedToken)
//        FirebaseApp.configure()
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
            print("Got notification title: ", response.notification.request.content.title)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
}
