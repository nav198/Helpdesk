//
//  ButtonAnimation.swift
//  Ed
//
//  Created by Beera Naveen on 23/05/25.
//

import Foundation
import SwiftUI

enum TaskStatus:Equatable{
    case idle
    case failed(String)
    case success
}

struct CustomButton<ButtonContent: View>: View {
    var content:()->ButtonContent
    var action:() async -> TaskStatus
    @State var taskStatus:TaskStatus = .idle
    @State var isLoading:Bool = false
    @State var isFailed:Bool = false
    @State var showPopup:Bool = false
    @State var wiggle:Bool = false
    @State var popupMesage:String = ""
  
    var body: some View {
        Button(action: {
            isLoading = true
            Task{
                let taskStatus = await action()
               switch taskStatus {
               case .idle:
                   isFailed = false
                  
                case .failed(let errorMessage):
                  isFailed = true
                   popupMesage = errorMessage
                case .success:
                   isFailed = false
                }
                self.taskStatus = taskStatus
                if isFailed{
                    try? await Task.sleep(for:.seconds(0))
                    wiggle.toggle()
                }
                try await Task.sleep(for: .seconds(0.8))
                if isFailed{
                    showPopup = true
                }
                self.taskStatus = .idle
                isLoading = false
                
            }
        }, label: {
            content()
                .padding(.horizontal,100)
                .padding(.vertical,12)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .frame(width: isLoading ? 50 : nil,height: isLoading ? 50 : nil)
                .background(Color(taskStatus == .idle ? .white : taskStatus == .success ? .green : .red).shadow(.drop(color:.black.opacity(0.15),radius: 6)),in:.capsule)
                .overlay{
                    if isLoading && taskStatus == .idle {
                        ProgressView()
                    }
                }
                .overlay{
                    if taskStatus != .idle {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .font(.title2.bold())
                            .foregroundStyle(Color.white)
                    }
                }
                .wiggle(wiggle)
        })

        .disabled(isLoading)
//        .popover(isPresented: $showPopup, content: {
//            Text(popupMesage)
//                .font(.caption)
//                .foregroundStyle(.gray)
//                .padding(.horizontal,10)
//                .presentationCompactAdaptation(.popover)
//        })
        .animation(.snappy, value: isLoading)
//        .animation(.snappy, value: taskStatus)
    }
}

extension View{
    @ViewBuilder
    
    func wiggle(_ animate:Bool)-> some View{
        if #available(iOS 17.0, *) {
            self.keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view.offset(x:value)
            } keyframes: { _ in
                KeyframeTrack{
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
