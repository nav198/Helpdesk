//
//  Profile.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 08/05/25.
//

import SwiftUI

struct Profile: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject  private var profileVM = UserProfileVM()
    @State private var isMyProfileLoading = false

    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                ZStack{
                    Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        ZStack {
                            LinearGradient(colors: [.gray.opacity(0.1), .green.opacity(0.6)], startPoint: .bottom, endPoint: .top)
                                .frame(height: 200)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 100)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                        
                        
                        
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
                        
                        
                        VStack(spacing: 0) {
                            sectionHeader(title: "Account")
                            Divider()
                            profileRow(icon: "lock.fill", text: "Change Password")
                            Divider()
                            profileRow(icon: "arrow.right.square.fill", text: "Logout")
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                        
                        Spacer()
 
                    }
                }
            }
            .loadingOverlay(isShowing: isMyProfileLoading)
            .onAppear{
                callUserProfile()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func callUserProfile() {
        isMyProfileLoading = true
        Task {
            await profileVM.fetchData()
            isMyProfileLoading = false
        }
    }

    
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

#Preview {
    Profile()
}
