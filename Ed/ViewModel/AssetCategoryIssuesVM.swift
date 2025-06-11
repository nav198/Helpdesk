//
//  AssetCategoryIssuesVM.swift
//  Ed
//
//  Created by Beera Naveen on 02/06/25.
//

import Foundation

@MainActor
class AssetCategoryIssuesVM: ObservableObject {
    @Published var data: [AssetIssueResponse]?  
    let webService = WebService.shared

    func fetchData(projectID: Int, category_id: Int, issueType: String) async {
        let url = API.Endpoint.assetIssueType(projectID: projectID, category_id: category_id, issue_type: issueType).url()
        let result: Result<AssetCategoryIssueResponse, NetworkError> = await webService.fetchData(from: url)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        switch result {
        case .success(let response):
            self.data = response.data
        case .failure(let error):
            print("❌ Error fetching data: \(error.localizedDescription)")
            self.data = nil
        }
    }
}
