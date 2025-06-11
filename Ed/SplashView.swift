//
//  ContentView.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 06/05/25.

import SwiftUI
import UserNotifications


enum AppViewState {
    case splash
    case login
    case dashboard
}

struct SplashView: View {
    @State private var isMenuOpen = false
    @State private var path = NavigationPath()
    @State private var showSplash = true
    @State private var showLogin = false
    let notificationCenter = UNUserNotificationCenter.current()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    @State private var viewState: AppViewState = .splash
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                switch viewState {
                case .splash:
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .onAppear {
                            Task {
                                do {
                                    try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
                                } catch {
                                    print("Request authorization error")
                                }
                            }
                            if isLoggedIn {
                                viewState = .dashboard
                            } else {
                                viewState = .splash
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    withAnimation {
                                        viewState = .login
                                    }
                                }
                            }
                        }
                case .login:
                    Login {
                        withAnimation {
                            appState.isLoggedIn = true
                            viewState = .dashboard
                        }
                    }
                case .dashboard:
                    ZStack(alignment: .leading) {
                        Dashboard()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        withAnimation {
                                            isMenuOpen.toggle()
                                        }
                                    }) {
                                        Image(systemName: "line.horizontal.3")
                                            .imageScale(.large)
                                            .padding(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }

                            .navigationBarBackButtonHidden(true)
                        if isMenuOpen {
                            Color.black.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        isMenuOpen = false
                                    }
                                }
                            SideMenuView(isMenuOpen: $isMenuOpen, path: $path)
                                .frame(width: 260)
                                .transition(.move(edge: .leading))
                                .zIndex(1)
                        }
                    }
                }
            }
            .onChange(of: appState.isLoggedIn) { newValue in
                if !newValue {
                    withAnimation {
                        viewState = .splash
                        path = NavigationPath()
                        isMenuOpen = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation {
                            viewState = .login
                        }
                    }
                }
            }
            .navigationDestination(for: MenuDestination.self) { destination in
                switch destination {
                case .profile: Profile()
                case .about: AboutView()
                case .contact: ContactView()
                case .terms_conditions: TermsConditionsView()
                case .privacy: PrivacyView()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { _ in
            appState.isLoggedIn = false
            path = NavigationPath()
            showLogin = true
        }
    }
}


