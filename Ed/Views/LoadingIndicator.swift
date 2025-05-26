//
//  LoadingIndicator.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 08/05/25.
//

import SwiftUI

struct LoadingIndicatorView: View {
    @State private var rotation = 0.0
    @State private var trimEnd: CGFloat = 0.6
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: trimEnd)
            .stroke(
                LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
            )
            .frame(width: 60, height: 60)
            .rotationEffect(Angle(degrees: rotation))
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    trimEnd = 0
                }
            }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView()
    }
}

extension View {
    func loadingOverlay(isShowing: Bool) -> some View {
        ZStack {
            self
            if isShowing {
                if #available(iOS 14.0, *) {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                } else {
                    // Fallback on earlier versions
                }
                LoadingIndicatorView()
            }
        }
    }
}
