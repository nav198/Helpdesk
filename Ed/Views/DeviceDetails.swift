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
    @StateObject private var serviceHistory = ServiceHistoryVM()
    @State private var isMyDevicesLoading = false
    
    @State var serviceHistoryList : [ServiceHistoryData] = []
    
    @State private var selectedTab: Tab = .details
    var data = ["USER MANUAL", "REQUEST FOR SERVICE", "FAQ"]
    let images = ["applelogo", "leaf", "cart.fill"]
    enum Tab {
        case details, serviceHistory
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                // Tabs
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
                Group {
                    if selectedTab == .details {
                        deviceDetailsView
                    } else {
                        serviceHistoryView
                    }
                }
                .animation(.easeInOut, value: selectedTab)

                Spacer()
                if selectedTab == .details{
                    bottomButtonsView
                }
                
            }
//            .loadingOverlay(isShowing: isMyDevicesLoading)
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
    
    func serviceHistoryAPI() {
        isMyDevicesLoading = true
        Task {
            await serviceHistory.fetchData()

            if let allHistory = serviceHistory.serviceHistoryData {
                let filtered = allHistory.filter { $0.asset?.id == device.id }
                self.serviceHistoryList = filtered
            }
            isMyDevicesLoading = false
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
//                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
        }
    }
    
    private var serviceHistoryView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if serviceHistoryList.isEmpty {
                    Text("No service history available.")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(serviceHistoryList, id: \.id) { history in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Ticket #\(history.id)")
                                    .font(.headline)
                                Spacer()
                                if history.status.lowercased() == "open" {
                                    Text(history.status.capitalized)
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                }else{
                                    Text(history.status.capitalized)
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                               
                            }

                            if let asset = history.asset {
                                Text("Asset: \(asset.itemMake) \(asset.itemModelName)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Serial No: \(asset.itemSerialNo)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Text("Problem: \(history.problem_category) > \(history.problem_sub_category)")
                                .font(.subheadline)

                            Text("Description: \(history.problem_description)")
                                .font(.caption)

                            Text("Opened: \(convertToIST(from: "\(history.open_date)"))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray5))
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .loadingOverlay(isShowing: isMyDevicesLoading)
        .onAppear {
            serviceHistoryAPI()
        }
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



struct ButtonItem {
    let title: String
    let icon: String
}

let buttonsData: [ButtonItem] = [
    ButtonItem(title: "USER MANUAL", icon: "camera.fill"),
    ButtonItem(title: "SERVICE", icon: "plus.circle.fill"),
    ButtonItem(title: "FAQ", icon: "arrow.up.circle.fill")
]
