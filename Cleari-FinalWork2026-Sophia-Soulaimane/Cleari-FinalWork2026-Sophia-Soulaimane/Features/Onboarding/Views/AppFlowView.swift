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
    case consultationForm
    case scan
}

struct AppFlowView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(
                onLogin: {
                    path.append(AppRoute.login)
                },
                onRegister: {
                    path.append(AppRoute.rolePicker)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .welcome:
                    WelcomeView(
                        onLogin: {
                            path.append(AppRoute.login)
                        },
                        onRegister: {
                            path.append(AppRoute.rolePicker)
                        }
                    )

                case .login:
                    LoginView(
                        onSuccess: {
                            path.append(AppRoute.scan)
                        },
                        onRegister: {
                            path.append(AppRoute.rolePicker)
                        }
                    )

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
                    UserRegisterView(
                        onSuccess: {
                            print("APPFLOW RECEIVED SUCCESS → GO TO FORM")
                            path = NavigationPath()
                            path.append(AppRoute.consultationForm)
                        },
                        onBack: {
                            path.removeLast()
                        }
                    )

                case .dermatologistRegister:
                    DermatologistRegisterView {
                        path.append(AppRoute.scan)
                    }

                case .consultationForm:
                    ConsultationFormView()

                case .scan:
                    CameraCaptureView()
                }
            }
        }
    }
}
