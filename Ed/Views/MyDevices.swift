//
//  MyDevices.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 06/05/25.
//

import Foundation
import SwiftUI

struct MyDevicesView: View {
    @State private var isMyDevicesLoading = false
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @StateObject private var devicesList = DevicesListVM()

    var filteredDevices: [Results] {
        guard let results = devicesList.devices else { return [] }
        if searchText.isEmpty {
            return results
        } else {
            return results.filter {
                ($0.itemSerialNo ?? "").lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        if #available(iOS 14.0, *) {
            VStack(spacing: 20) {
                
                HStack {
                    TextField("Enter last 3 digits of M/C to search", text: $searchText)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(25)
                        .padding(.horizontal, 5)
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchText.isEmpty {
                                    Button(action: {
                                        searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 10)
                                }
                            }
                        )
                }

                // 📦 Device Count
                Text("\(filteredDevices.count) devices found")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(25)
                    .padding(.horizontal, 50)

                // 📋 Device List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredDevices, id: \.id) { device in
                            NavigationLink(destination: DeviceDetailView(device: device)) {
                                let card = DeviceCard(
                                    deviceName: device.itemMake ?? "Unknown",
                                    deviceType: device.itemCategory ?? "Unknown",
                                    model: device.itemModelName ?? "N/A"
                                )
                                DeviceCardView(device: card)
                            }

                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 0)
                    .padding(.horizontal, -10)
                }
            }
            .padding()
            .loadingOverlay(isShowing: isMyDevicesLoading)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationTitle("My Devices")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
               myDevicesList()
            }
        } else {
            Text("Unsupported iOS version")
        }
    }

    func myDevicesList() {
        isMyDevicesLoading = true
        Task {
            await devicesList.fetchData()
            print("DATA OF MY DEVICES \(devicesList.devices)")
            isMyDevicesLoading = false
        }
    }
}


struct MyDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                MyDevicesView()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
