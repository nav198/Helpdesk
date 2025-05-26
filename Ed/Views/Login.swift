//
//  Login.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 13/05/25.
//

import SwiftUI
//import GoogleSignInSwift
//import GoogleSignIn
//import FirebaseCore
//import FirebaseAuth
import AuthenticationServices
import CryptoKit
import AuthenticationServices


@available(iOS 16.0, *)
struct Login: View {
    
    @State private var angle: Double = 0.0
    @State private var timer: Timer?
    @State private var showError = false
    @State private var navigate = false
    
    @State private var email = ""
    @State private var isEmailValid: Bool = true
    @State private var password = ""
    @State private var isSecure = true
    
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var triggerFailureAnimation = false
    @StateObject private var loginVM = UserLoginVM()
   
    @EnvironmentObject var appState: AppState
    @State private var showDashboard = false
    @State private var isMenuOpen = false
    @State private var path = NavigationPath()
       
    @State private var showToast = false

    var onLoginSuccess: () -> Void
    var body: some View {
        ZStack {
            
            VStack(spacing: 30) {
                
                // Avatar
                Image(systemName: "person.circle.fill")
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
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    
                    Group {
                        if isSecure {
                            SecureField("Password", text: $password)
                        } else {
                            TextField("Password", text: $password)
                        }
                    }
                    
                    Button(action: { isSecure.toggle() }) {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 1))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
                .padding(.horizontal, 25)
                
                NavigationLink(destination: ForgotPasswordView( onLoginSuccess: {
                    
                })) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
 
                if showError {
                    Text("Please enter both email and password")
                        .foregroundColor(.red)
                }
                
             
                CustomButton{
                    HStack(spacing:10){
                        Text("Login")
                        Image(systemName: "chevron.right")
                    }
                    
                    .foregroundStyle(Color.green)
                    .fontWeight(.bold)
                }action: {
                   await callLogin()
                }
               
             
                
                Spacer()
                
            }
            .padding(.top,50)
            .background(
                LinearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
        .withToast()
    }
    
    func callLogin() async -> TaskStatus {
        guard !email.isEmpty, !password.isEmpty else {
            ToastManager.shared.show(message: "Email and password required", type: .success)
            return .failed("Login Failed")
        }
        
        print("NEWWWWW")
        
        let success = await loginVM.loginUser(email, password)

        if success {

            ToastManager.shared.show(message: "Login successful!", type: .success)
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            onLoginSuccess()
            appState.isLoggedIn = true
            
            return .success
        } else {
            let errorMsg = loginVM.errorMessage ?? "Login failed. Please try again."
            ToastManager.shared.show(message: errorMsg, type: .failure)
            
            return .failed(errorMsg)
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        Login {
            print("Login succeeded (Preview)")
        }
    } else {
        // Fallback on earlier versions
    }
}
