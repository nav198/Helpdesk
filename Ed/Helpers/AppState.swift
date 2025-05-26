//
//  AppState.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 08/05/25.
//

import Foundation

import SwiftUI

@available(iOS 14.0, *)
class AppState: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
}
