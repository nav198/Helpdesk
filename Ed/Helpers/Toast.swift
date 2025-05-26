//
//  Toast.swift
//  Ed
//
//  Created by Beera Naveen on 23/05/25.
//

import Foundation
import SwiftUI

import SwiftUI
import Combine

// 1. Toast type enum
enum ToastType {
    case success
    case failure
}

// 2. ToastManager singleton class
final class ToastManager: ObservableObject {
    static let shared = ToastManager()

    @Published var message: String = ""
    @Published var isShowing: Bool = false
    @Published var type: ToastType = .success

    private var hideCancellable: AnyCancellable?

    func show(message: String, type: ToastType = .success, duration: TimeInterval = 2) {
        self.message = message
        self.type = type

        withAnimation {
            self.isShowing = true
        }

        hideCancellable?.cancel()
        hideCancellable = Just(())
            .delay(for: .seconds(duration), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                withAnimation {
                    self?.isShowing = false
                }
            }
    }
}

// 3. Toast view showing message & colors
struct ToastView: View {
    let message: String
    let type: ToastType

    private var backgroundColor: Color {
        switch type {
        case .success:
            return Color.green.opacity(0.85)
        case .failure:
            return Color.red.opacity(0.85)
        }
    }

    private var foregroundColor: Color {
        Color.white
    }

    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .cornerRadius(8)
            .padding(.bottom, 140)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

// 4. View modifier to add Toast overlay
struct ToastContainer: ViewModifier {
    @ObservedObject var toastManager = ToastManager.shared

    func body(content: Content) -> some View {
        ZStack {
            content
            if toastManager.isShowing {
                VStack {
                    Spacer()
                    ToastView(message: toastManager.message, type: toastManager.type)
                }
                .zIndex(1)
                .animation(.easeInOut, value: toastManager.isShowing)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

extension View {
    func withToast() -> some View {
        self.modifier(ToastContainer())
    }
}
