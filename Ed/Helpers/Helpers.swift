//
//  Helpers.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 07/05/25.
//

import Foundation
import SwiftUI
import StoreKit
import CryptoKit

struct DeviceCard: Identifiable {
    let id = UUID()
    let deviceName: String
    let deviceType: String
    let model: String
}

struct DeviceCardView: View {
    let device: DeviceCard
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image("cpu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .background(Color.green)
                .clipShape(Circle())
                .padding(.leading, 20)
            VStack(alignment: .leading, spacing: 4) {
                Text(device.deviceName.uppercased())
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(device.deviceType.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Serial-\(device.model)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.2)))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}


#Preview {
    DeviceCardView(device: DeviceCard(deviceName: "M229", deviceType: "CPU", model: "Acer 1234"))
}

struct CustomBackButton {
    static func view(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AppReviewManager {
    static func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: windowScene)
            } else {
            }
        }
    }
}

func validateEmail(_ string: String) -> Bool {
    if string.count > 100 {
        return false
    }
    let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: string)
}
