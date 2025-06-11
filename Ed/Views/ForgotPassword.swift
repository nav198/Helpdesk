//
//  ForgotPassword.swift
//  Ediq
//
//  Created by Beera Naveen on 14/05/25.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    var onLoginSuccess: () -> Void
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack{
            VStack(spacing:30) {
                
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .foregroundColor(.black.opacity(0.6))
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: email) { newValue in
                            isEmailValid = validateEmail(newValue)
                        }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isEmailValid ? Color.blue : Color.red, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
                .padding(.horizontal, 25)
                
                if !isEmailValid && !email.isEmpty {
                    Text("Please enter a valid email address")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, -10)
                }
                
    
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back to Login")
                        .foregroundStyle(Color.white)
                        .font(.subheadline)
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top,50)
            .background(
                LinearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }
}

