//
//  AppFlowView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 03/05/2026.
//

import SwiftUI

enum AppRoute: Hashable {
    case welcome
    case login
    case rolePicker
    case userRegister
    case dermatologistRegister
    case dermPending
    case consultationForm
    case userHome
    case scan
}

struct AppFlowView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var path = NavigationPath()
    @State private var isCheckingSession = true

    var body: some View {
        Group {
            if isCheckingSession {
                sessionCheckView
            } else {
                navigationStack
            }
        }
        .task {
            await checkExistingSession()
        }
    }

    // Minimal splash shown while validating a stored token
    private var sessionCheckView: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("cleari")
                    .font(AppFont.gillSwiftUI(.regular, size: 48))
                    .foregroundColor(Color(hex: "1A1018"))
                ProgressView()
                    .tint(Color(hex: "1A1018"))
            }
        }
    }

    private var navigationStack: some View {
        NavigationStack(path: $path) {
            WelcomeView {
                path.append(AppRoute.login)
            } onRegister: {
                path.append(AppRoute.rolePicker)
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {

                case .welcome:
                    WelcomeView {
                        path.append(AppRoute.login)
                    } onRegister: {
                        path.append(AppRoute.rolePicker)
                    }

                case .login:
                    LoginView {
                        path = NavigationPath()
                        if TokenStorage.shared.userRole == "dermatologist" {
                            let status = TokenStorage.shared.dermVerificationStatus ?? "pending"
                            if status == "approved" {
                                path.append(AppRoute.userHome)
                            } else {
                                path.append(AppRoute.dermPending)
                            }
                        } else {
                            // Returning user: skip form if already completed
                            if TokenStorage.shared.hasCompletedSkinForm {
                                path.append(AppRoute.userHome)
                            } else {
                                path.append(AppRoute.consultationForm)
                            }
                        }
                    } onRegister: {
                        path.append(AppRoute.rolePicker)
                    }

                case .rolePicker:
                    RolePickerView { role in
                        if role == "User" {
                            path.append(AppRoute.userRegister)
                        } else {
                            path.append(AppRoute.dermatologistRegister)
                        }
                    } onLogin: {
                        path.append(AppRoute.login)
                    }

                case .userRegister:
                    UserRegisterView {
                        print("USER REGISTER SUCCESS → GO TO FORM")
                        path = NavigationPath()
                        path.append(AppRoute.consultationForm)
                    } onBack: {
                        path.removeLast()
                    }

                case .dermatologistRegister:
                    DermatologistRegisterView {
                        path = NavigationPath()
                        path.append(AppRoute.dermPending)
                    }

                case .dermPending:
                    DermatologistPendingApprovalView {
                        authViewModel.logout()
                    }

                case .consultationForm:
                    ConsultationFormView {
                        TokenStorage.shared.hasCompletedSkinForm = true
                        path = NavigationPath()
                        path.append(AppRoute.userHome)
                    }

                case .userHome:
                    UserHomeShellView()
                        .environmentObject(authViewModel)

                case .scan:
                    CameraCaptureView()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { _ in
                path = NavigationPath()
            }
        }
    }

    private func checkExistingSession() async {
        guard TokenStorage.shared.token != nil else {
            isCheckingSession = false
            return
        }

        if let destination = await authViewModel.validateSession() {
            path = NavigationPath()
            path.append(destination)
        }

        isCheckingSession = false
    }
}
