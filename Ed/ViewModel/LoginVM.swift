//
//  LoginVM.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation


@MainActor
class UserLoginVM: ObservableObject {

    @Published var loginData: LoginDataResponse? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    let webService = WebService.shared

    func loginUser(_ email: String, _ password: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        let url = API.Endpoint.userLogin.url()
        let loginBody = LoginRequest(email: email.lowercased(), password: password)

        let result: Result<LoginDataResponse, NetworkError> =
            await webService.postData(to: url, body: loginBody, responseType: LoginDataResponse.self)

        isLoading = false

        switch result {
        case .success(let response):
            self.loginData = response
            handleLoginSuccess(response: response)
            return true
        case .failure(let error):
            errorMessage = "Login failed: Please try later"
            return false
        }
    }

    private func handleLoginSuccess(response: LoginDataResponse) {
        KeychainHelper.shared.save(response.data.access_token, key: "accessToken")
        KeychainHelper.shared.save(response.data.refresh_token, key: "refreshToken")
        UserDefaults.standard.set(response.data.email, forKey: "userEmail")
    }
}
