//
//  ServicePostVM.swift
//  Ed
//
//  Created by Beera Naveen on 28/05/25.
//

import Foundation


@MainActor
class ServicePostVM: ObservableObject {

    @Published var serviceRequestRes: ServiceRequestResponse? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    let webService = WebService.shared

    func requestForService(_ typeOfProblem: String, _ selectIssue: String,_ comments: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        let url = API.Endpoint.requestForService.url()
        let requestBody = ServiceRequestResponse(project_id: 0, institute_id: 0, asset_id: 0, item_category: "", problem_category: "", problem_sub_category: "", problem_description: "", ticket_complaint: "", status: "")

        let result: Result<ServiceRequestResponse, NetworkError> =
            await webService.postData(to: url, body: requestBody, responseType: ServiceRequestResponse.self)

        isLoading = false

        switch result {
        case .success(let response):
            self.serviceRequestRes = response
            return true
        case .failure(let error):
            errorMessage = "Post failed: \(error.localizedDescription)"
            return false
        }
    }


}
