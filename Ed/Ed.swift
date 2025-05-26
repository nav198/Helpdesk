//
//  EdiqueSupportApp.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 06/05/25.
//

import SwiftUI

@main
struct Ed: App {
    @StateObject private var appState = AppState()
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate

    init() {
        // Global navigation bar appearance
        let appearance = UINavigationBarAppearance()
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemGreen.cgColor]
        
        UIGraphicsBeginImageContext(gradient.frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        appearance.backgroundImage = backgroundImage
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .onAppear(perform: {
                    appDelegate.app = self
                })
                .environmentObject(appState)
        }
    }
}

