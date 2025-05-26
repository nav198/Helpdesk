//
//  UserProfileVM.swift
//  Ediq
//
//  Created by Beera Naveen on 22/05/25.
//

import Foundation

@MainActor
class UserProfileVM: ObservableObject {
    @Published var userProfileData: UserProfile? = nil
    let webService = WebService.shared

    func fetchData() async {
        let url = API.Endpoint.userProfile(userID: 4539).url()
        let result: Result<UserProfile, NetworkError> = await webService.fetchData(from: url)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        switch result {
        case .success(let response):
            self.userProfileData = response
        case .failure(let error):
            print("❌ Error fetching data: \(error.localizedDescription)")
        }
    }
}
