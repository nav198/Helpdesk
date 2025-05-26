//
//  Dummy.swift
//  Ed
//
//  Created by Beera Naveen on 23/05/25.
//

import Foundation
import SwiftUI

struct DeviceDetailViewww: View {
    @Environment(\.presentationMode) var presentationMode
    let device: Results
    @State private var showOverlay = false

    @State private var selectedTab: Tab = .details
    enum Tab {
        case details, serviceHistory
    }
    
    var body: some View {
        ZStack {
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
                
                HStack(spacing: 12) {
                    ForEach(buttonsData, id: \.title) { item in
                        Button(action: {
                            print("Tapped on \(item.title)")
                            if item.title == "SERVICE" {
                                withAnimation {
                                    showOverlay = true
                                }
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
            .disabled(showOverlay) // disable interaction when overlay is active
            
            // MARK: Overlay View
            if showOverlay {
                // Dimmed background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showOverlay = false
                        }
                    }
                
                // Overlay content
                VStack(spacing: 20) {
                    Text("Service Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    serviceHistoryView
                    
                    Button(action: {
                        withAnimation {
                            showOverlay = false
                        }
                    }) {
                        Text("Close")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .frame(maxWidth: 350)
                .padding(.horizontal)
                .transition(.scale)
            }
        }
        .navigationTitle(device.itemModelName ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton.view {
            presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitleDisplayMode(.inline)
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
        [
            ("MAKE", device.itemMake ?? "Unknown"),
            ("MODEL", device.itemModelName ?? "N/A"),
            ("SERVICE PROVIDER", "\(device.assetServiceProvider)"),
            ("CATEGORY", device.itemCategory ?? "Unknown"),
            ("INSTALLATION DATE", device.backdatedDate ?? "Unknown"),
        ]
    }
}
