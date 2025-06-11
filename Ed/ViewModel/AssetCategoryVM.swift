//
//  AssetCategoryVM.swift
//  Ed
//
//  Created by Beera Naveen on 02/06/25.
//

import Foundation

@MainActor
class AssetCategoryVM: ObservableObject {
    @Published var data: [DataResponse]?
    let webService = WebService.shared

    func fetchData() async {
        let url = API.Endpoint.assetCategory(projectID: 5).url()
        let result: Result<AssetCategoryResponse, NetworkError> = await webService.fetchData(from: url)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        switch result {
        case .success(let response):
            self.data = response.data
        case .failure(let error):
            print("❌ Error fetching data: \(error.localizedDescription)")
            self.data = []
        }
    }
}
