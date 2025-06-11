//
//  DevicesListVM.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation

@MainActor
class DevicesListVM: ObservableObject {
    @Published var devices: [Results]? = nil
    let webService = WebService.shared

    func fetchData() async {
        let url = API.Endpoint.devicesList(projectID: 5).url()
        let result: Result<AssetDetails, NetworkError> = await webService.fetchData(from: url)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        switch result {
        case .success(let response):
            self.devices = response.data
        case .failure(let error):
            print("❌ Error fetching data: \(error.localizedDescription)")
            self.devices = []
        }
    }
}
