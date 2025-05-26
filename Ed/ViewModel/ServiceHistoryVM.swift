//
//  ServiceHistoryVM.swift
//  Ed
//
//  Created by Beera Naveen on 26/05/25.

import Foundation

@MainActor
class ServiceHistoryVM: ObservableObject {
    @Published var serviceHistoryData: [ServiceHistoryData]? = nil
    let webService = WebService.shared

    func fetchData() async {
        let url = API.Endpoint.serviceHistory(projectID: 5).url()
        let result: Result<ServiceHistoryResponse, NetworkError> = await webService.fetchData(from: url)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        switch result {
        case .success(let response):
            self.serviceHistoryData = response.data
        case .failure(let error):
            print("❌ Error fetching data: \(error.localizedDescription)")
        }
    }
}
