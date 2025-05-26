//
//  UserProfile.swift
//  Ed
//
//  Created by Beera Naveen on 26/05/25.
//

import Foundation
import SwiftUI

//struct Profile: View {
//    @State private var isMyProfileLoading = false
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var profileVM = UserProfileVM()
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//
//                // MARK: - Profile Header Card
//                VStack(spacing: 12) {
//                    LinearGradient(colors: [.green.opacity(0.8), .white.opacity(0.6)],
//                                   startPoint: .top, endPoint: .bottom)
//                        .frame(height: 200)
//                        .cornerRadius(20)
//                        .overlay(
//                            VStack(spacing: 12) {
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 100, height: 100)
//                                    .foregroundColor(.white)
//
//                                Text(profileVM.userProfileData?.data.first_name ?? "User Name")
//                                    .font(.title3)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.white)
//                            }
//                        )
//                }
//                .padding(.horizontal)
//
//                // MARK: - Profile Info Section
//                VStack(spacing: 0) {
//                    profileRow(icon: "person.fill", text: profileVM.userProfileData?.data.first_name ?? "")
//                    Divider()
//                    profileRow(icon: "envelope.fill", text: profileVM.userProfileData?.data.email ?? "")
//                    Divider()
//                    profileRow(icon: "phone.fill", text: profileVM.userProfileData?.data.contact_number ?? "")
//                }
//                .background(Color(UIColor.secondarySystemBackground))
//                .cornerRadius(16)
//                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//                .padding(.horizontal)
//
//                // MARK: - Account Section
//                VStack(spacing: 0) {
//                    sectionHeader(title: "Account")
//                    Divider()
//                    profileRow(icon: "lock.fill", text: "Change Password")
//                    Divider()
//                    profileRow(icon: "arrow.right.square.fill", text: "Logout")
//                }
//                .background(Color(UIColor.secondarySystemBackground))
//                .cornerRadius(16)
//                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
//                .padding(.horizontal)
//
//                Spacer()
//                
//                // MARK: - Logout Button Fixed at Bottom
//                        
//                
//                
//            }
//            .padding(.top,30)
//            
//        }
//        .navigationBarItems(leading: CustomBackButton.view {
//            presentationMode.wrappedValue.dismiss()
//        })
//        .navigationBarBackButtonHidden(true)
//        .loadingOverlay(isShowing: isMyProfileLoading)
//        .navigationTitle("My Profile")
//        .onAppear {
//            callUserProfile()
//        }
//    }
//
//    // MARK: - API Call
//    func callUserProfile() {
//        isMyProfileLoading = true
//        Task {
//            await profileVM.fetchData()
//            isMyProfileLoading = false
//        }
//    }
//
//    // MARK: - Profile Row
//    func profileRow(icon: String, text: String) -> some View {
//        HStack(spacing: 16) {
//            Image(systemName: icon)
//                .foregroundColor(Color(UIColor.gray))
//                .frame(width: 24)
//            Text(text)
//                .font(.body)
//                .foregroundColor(Color(UIColor.label))
//            Spacer()
//        }
//        .padding()
//    }
//
//    // MARK: - Section Header
//    func sectionHeader(title: String) -> some View {
//        HStack {
//            Text(title.uppercased())
//                .font(.caption)
//                .foregroundColor(.gray)
//            Spacer()
//        }
//        .padding([.top, .horizontal])
//    }
//}
//
//
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
        
            .previewDevice("iPhone 13 Pro Max")
            .preferredColorScheme(.light)
    }
}

struct Profile: View {
    @State private var isMyProfileLoading = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showLogoutAlert = false
    @StateObject private var profileVM = UserProfileVM()
//    @EnvironmentObject var appState: AppState
//    @Binding var path: NavigationPath
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Profile Header Card
                    VStack(spacing: 12) {
                        LinearGradient(colors: [.green.opacity(0.8), .white.opacity(0.6)],
                                       startPoint: .top, endPoint: .bottom)
                            .frame(height: 200)
                            .cornerRadius(20)
                            .overlay(
                                VStack(spacing: 12) {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.white)

                                }
                            )
                    }
                    .padding(.horizontal)

                    // MARK: - Profile Info Section
                    VStack(spacing: 0) {
                        profileRow(icon: "person.fill", text: profileVM.userProfileData?.data.first_name ?? "")
                        Divider()
                        profileRow(icon: "envelope.fill", text: profileVM.userProfileData?.data.email ?? "")
                        Divider()
                        profileRow(icon: "phone.fill", text: profileVM.userProfileData?.data.contact_number ?? "")
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                    // MARK: - Account Section
                    VStack(spacing: 0) {
                        sectionHeader(title: "Account")
                        Divider()
                        profileRow(icon: "lock.fill", text: "Change Password")
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    .padding(.horizontal)

                    Spacer(minLength: 20)
                }
                .padding(.top, 30)
            }

            // MARK: - Logout Button Fixed at Bottom
//            Button(action: {
//                print("Logout tapped")
//                Alert(
//                    title: Text("Confirm Logout"),
//                    message: Text("Are you sure you want to log out?"),
//                    primaryButton: .destructive(Text("Logout")) {
////                        appState.isLoggedIn = false
////                        path = NavigationPath()
//                    },
//                    secondaryButton: .cancel()
//                )
//                // Add your logout logic here
//            }) {
//                Text("Logout")
//                    .foregroundColor(.primary)
//                    .frame(maxWidth: UIScreen.main.bounds.width/4)
//                    .padding()
//                    .background(Color.red)
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//            }
//            .padding(.bottom, 20)
        }
        .navigationBarItems(leading: CustomBackButton.view {
            presentationMode.wrappedValue.dismiss()
        })
        .navigationBarBackButtonHidden(true)
        .loadingOverlay(isShowing: isMyProfileLoading)
        .navigationTitle("My Profile")
        .onAppear {
            callUserProfile()
        }
    }

    // MARK: - API Call
    func callUserProfile() {
        isMyProfileLoading = true
        Task {
            await profileVM.fetchData()
            isMyProfileLoading = false
        }
    }

    // MARK: - Profile Row
    func profileRow(icon: String, text: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Color(UIColor.gray))
                .frame(width: 24)
            Text(text)
                .font(.body)
                .foregroundColor(Color(UIColor.label))
            Spacer()
        }
        .padding()
    }

    // MARK: - Section Header
    func sectionHeader(title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding([.top, .horizontal])
    }
}
