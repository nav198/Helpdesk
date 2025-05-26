//
//  Dashboard.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 07/05/25.
//

import SwiftUI

struct Dashboard: View {
    @State private var showNotifications = false
    
    private let menuItems: [SupportMenuItem] = [
        .init(title: "My Devices", iconName: "desktopcomputer", borderColor: .red, destination: AnyView(MyDevicesView())),
        .init(title: "Service History", iconName: "gearshape.fill", borderColor: .green, destination: AnyView(ServiceHistory())),
//        .init(title: "Service Requests", iconName: "gearshape.fill", borderColor: .green, destination: AnyView(MaintainanceRequest( device: DeviceCard(deviceName: "", deviceType: "", model: "11")))),
        .init(title: "FAQs", iconName: "questionmark.circle.fill", borderColor: .yellow, destination: AnyView(FAQsView())),
        .init(title: "Contact", iconName: "info.circle", borderColor: .blue, destination: AnyView(ContactView()))
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Image("home")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(15)
                    .padding(.top, -10)
                VStack(spacing: 20) {
                    ForEach(menuItems) { item in
                        NavigationLink(destination: item.destination) {
                            SupportMenuButton(title: item.title, iconName: item.iconName, borderColor: item.borderColor)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    CircleButton(iconName: "phone.fill", backgroundColor: .green, action: {
                        print("CALL NUMber")
                        guard let phoneNum = URL(string: "tel://919675186584") else {return}
                        UIApplication.shared.open(phoneNum)
                    })
                    Spacer()
                    
                    ZStack(alignment: .topTrailing) {
                        CircleButton(iconName: "bell.fill", backgroundColor: .blue, action: {
                            print("🔔 Bell tapped")
                            showNotifications = true
                        })
                        Text("2")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.green)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                    .navigationDestination(isPresented: $showNotifications) {
                        Notifications()
                    }
                    
                    Spacer()
                }
                .padding(.bottom)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Edique Support")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
    }
}


#Preview {
    Dashboard()
}
