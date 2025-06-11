//
//  SideMenu.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 08/05/25.
//

import Foundation
import SwiftUI
import StoreKit

struct MenuItem: View {
    var icon: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }   
}

enum MenuDestination: Hashable {
    case profile
    case about
    case contact
    case terms_conditions
    case privacy
}

@available(iOS 14.0, *)
struct SideMenuView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isMenuOpen: Bool
    @Binding var path: NavigationPath
    @State private var showLogoutAlert = false
    @State private var isShowingShareSheet = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image("personImg")   
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .padding(.top,50)
                Spacer()
            }
            .padding(.top, 80)
            Spacer().frame(height: 30)
            
            Text("High School Bangali Girls Ckp")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            Divider().background(Color.white)
            
            Group {
                MenuItem(icon: "person", title: "Profile") {
                    navigate(to: .profile)
                }
                
                MenuItem(icon: "info.circle", title: "About Us") {
                    navigate(to: .about)
                }
                
                MenuItem(icon: "phone", title: "Contact Us") {
                    sendEmail(to: "info@edique.in")
                }
                
                MenuItem(icon: "doc.text", title: "Terms & Conditions") {
                    navigate(to: .terms_conditions)
                }
                
                MenuItem(icon: "lock.shield", title: "Privacy Policy") {
                    navigate(to: .privacy)
                }
                
                MenuItem(icon: "star", title: "Rate Us") {
                    AppReviewManager.requestReview()
                }
                
                MenuItem(icon: "square.and.arrow.up", title: "Share") {
//                    navigate(to: .share)
                    isShowingShareSheet = true
                }
                
                MenuItem(icon: "arrow.backward.square", title: "Logout") {
                    showLogoutAlert = true
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isShowingShareSheet) {
                ShareSheet(activityItems: [
                    "Check out this awesome app!",
                    URL(string: "https://apps.apple.com/app/id1234567890")!
                ])
            }
        .frame(width: 260)
        .background(LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Confirm Logout"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Logout")) {
                    appState.isLoggedIn = false
                    path = NavigationPath()
                },
                secondaryButton: .cancel()
            )
        }
    }

    
    private func navigate(to destination: MenuDestination) {
        withAnimation {
            isMenuOpen = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            path.append(destination)
        }
    }
    
    private func sendEmail(to address: String) {
           if let url = URL(string: "mailto:\(address)") {
               UIApplication.shared.open(url)
           }
       }
}

