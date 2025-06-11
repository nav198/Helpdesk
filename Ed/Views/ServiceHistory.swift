//
//  ServiceRequestsView.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 06/05/25.
//

import SwiftUI

struct ServiceHistory: View {
    @State private var isServiceHistoryLoading = false
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @StateObject private var serviceHistory = ServiceHistoryVM()

    var filteredServiceHistory: [ServiceHistoryData] {
        if searchText.isEmpty {
            return serviceHistory.serviceHistoryData ?? []
        } else {
            return serviceHistory.serviceHistoryData?.filter {
                $0.problem_description.localizedCaseInsensitiveContains(searchText) ||
                $0.problem_category.localizedCaseInsensitiveContains(searchText) ||
                $0.complaint_by_user.localizedCaseInsensitiveContains(searchText)
            } ?? []
        }
    }

    var body: some View {
            VStack {
                if filteredServiceHistory.isEmpty {
                    Text("No service history found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(filteredServiceHistory, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(item.item_category)
                                    .font(.headline)
                                Spacer()
                                Text(item.status.capitalized)
                                    .foregroundColor(item.status.lowercased() == "open" ? .red : .green)
                                    .font(.subheadline)
                            }

                            Text("Issue: \(item.problem_description)")
                                .font(.subheadline)
                            Text("Reported by: \(item.complaint_by_user)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Open Date: \(convertToIST(from: formattedDate(item.open_date)))")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarBackButtonHidden(true)
            .loadingOverlay(isShowing: isServiceHistoryLoading)
            .navigationTitle("Service History")
            .searchable(text: $searchText, prompt: "Search complaints")
            .onAppear {
                serviceHistoryAPI()
        }
    }

    func serviceHistoryAPI() {
        isServiceHistoryLoading = true
        Task {
            await serviceHistory.fetchData()
            isServiceHistoryLoading = false
        }
    }

    func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}

#Preview {
    ServiceHistory()
}
