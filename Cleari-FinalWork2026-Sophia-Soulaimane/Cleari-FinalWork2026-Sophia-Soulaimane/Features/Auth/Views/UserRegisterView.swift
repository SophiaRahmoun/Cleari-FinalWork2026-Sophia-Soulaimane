//
//  UserRegisterView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct UserRegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    @State private var selectedMonth = ""
    @State private var selectedDay = ""
    @State private var selectedYear = ""

    var body: some View {
        ZStack {
            RadialGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            VStack(spacing: 24) {
                TypographyLabel(
                    text: "Create your account",
                    style: .h1Italic,
                    color: .black
                )
                .padding(.top, 85)

                AuthRegisterInput(
                    label: "Voornaam",
                    text: $firstName,
                    maxLength: 50
                )

                AuthRegisterInput(
                    label: "Achternaam",
                    text: $lastName,
                    maxLength: 50
                )

                AuthRegisterInput(
                    label: "Email",
                    text: $email,
                    maxLength: 50
                )

                AuthRegisterInput(
                    label: "Password",
                    text: $password,
                    maxLength: 50
                )

                AuthBirthdatePicker(
                    selectedMonth: $selectedMonth,
                    selectedDay: $selectedDay,
                    selectedYear: $selectedYear
                )

                PrimaryButton(title: viewModel.isLoading ? "LOADING..." : "NEXT STEP") {
                    Task {
                        await viewModel.registerUser(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password
                        )
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 10)

                AuthBottomLink(
                    text: "Already have an account?",
                    linkText: "Sign in"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)

                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    UserRegisterView()
}
