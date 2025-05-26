//
//  DeviceDetails.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 07/05/25.
//

import SwiftUI

struct DeviceDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let device: Results
    @State private var showHalfSheet = false

    @State private var selectedTab: Tab = .details
    var data = ["USER MANUAL", "REQUEST FOR SERVICE", "FAQ"]
    let images = ["applelogo", "leaf", "cart.fill"]
    enum Tab {
        case details, serviceHistory
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 18) {
                HStack(spacing: 12) {
                    tabButton(title: "Details", isSelected: selectedTab == .details) {
                        selectedTab = .details
                    }
                    tabButton(title: "Service History", isSelected: selectedTab == .serviceHistory) {
                        selectedTab = .serviceHistory
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Tab Content
                if selectedTab == .details {
                    deviceDetailsView
                } else {
                    serviceHistoryView
                }
                
                Spacer()
                bottomButtonsView

//                HStack(spacing: 12) {
//                    ForEach(buttonsData, id: \.title) { item in
//                        Button(action: {
//                            print("Tapped on \(item.title)")
//                            
//                            if item.title == "SERVICE" {
//                                print("ITEM TITLE IS \(item.title)")
//                                showHalfSheet = true
//                            }
//                            
//                        }) {
//                            VStack {
//                                Spacer(minLength: 10)
//                                
//                                Image(systemName: item.icon)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 24, height: 24)
//                                    .foregroundColor(.white)
//                                
//                                Spacer(minLength: 8)
//                                
//                                Text(item.title)
//                                    .font(.footnote)
//                                    .foregroundColor(.white)
//                                
//                                Spacer()
//                            }
//                            .frame(height: 80)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green.opacity(0.7))
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 50)
            }
        }
        .navigationTitle(device.itemModelName ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton.view {
            presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $showHalfSheet) {
            ServiceRequest(device: device)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
    }
    
    private func toDeviceCard() -> DeviceCard {
        DeviceCard(
            deviceName: device.itemMake ?? "Unknown",
            deviceType: device.itemCategory ?? "Unknown",
            model: device.itemModelName ?? "N/A"
        )
    }

    
    private var bottomButtonsView: some View {
        HStack(spacing: 12) {
            ForEach(buttonsData, id: \.title) { item in
                Button(action: {
                    if item.title == "SERVICE" {
                        showHalfSheet = true
                    }
                }) {
                    VStack {
                        Spacer(minLength: 10)
                        Image(systemName: item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                        Spacer(minLength: 8)
                        Text(item.title)
                            .font(.footnote)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 50)
    }

    
    // MARK: - Reusable tab button
    private func tabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(.primary)
                .fontWeight(.medium)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.green.opacity(0.7) : Color.gray.opacity(0.3))
                .cornerRadius(20)
        }
        .foregroundColor(isSelected ? .white : .primary)
    }
    
    private var deviceDetailsView: some View {
        VStack(spacing: 30) {
            VStack() {
                DeviceCardView(device: DeviceCard(
                    deviceName: device.itemMake ?? "Unknown",
                    deviceType: device.itemCategory ?? "Unknown",
                    model: device.itemModelName ?? "N/A"
                ))

            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                ForEach(infoItems, id: \.0) { item in
                    HStack {
                        Text(item.0)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(item.1)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 12)
                    if item != infoItems.last! {
                        Divider()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
        }
    }
    
    private var serviceHistoryView: some View {
        VStack {
            Text("Service history goes here...")
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var infoItems: [(String, String)] {
       
        return [
            ("MAKE", device.itemMake ?? "Unknown"),
            ("MODEL", device.itemModelName ?? "N/A"),
            ("SERVICE PROVIDER", device.assetServiceProvider?.providerName ?? ""),
            ("CATEGORY", device.itemCategory ?? "Unknown"),
            ("WARRANTY END DATE", convertToIST(from: device.warrantyEndDate ?? "")),
        ]
    }

}

// MARK: - Preview
//struct DeviceDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            DeviceDetailView(device: DeviceCard(deviceName: "ACER M220", deviceType: "TFT", model: "MMRE8700377"))
//        }
//    }
//}


struct ButtonItem {
    let title: String
    let icon: String
}

let buttonsData: [ButtonItem] = [
    ButtonItem(title: "USER MANUAL", icon: "camera.fill"),
    ButtonItem(title: "SERVICE", icon: "plus.circle.fill"),
    ButtonItem(title: "FAQ", icon: "arrow.up.circle.fill")
]
