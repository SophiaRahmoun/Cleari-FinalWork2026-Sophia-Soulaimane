//
//  LoginView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(alignment: .leading, spacing: 32) {
                Spacer()

                TypographyLabel(
                    text: "Login",
                    style: .h1Italic,
                    color: .black
                )

                AuthTextField(
                    label: "Your e-mail address",
                    placeholder: "example@gmail.com",
                    text: $email
                )

                AuthTextField(
                    label: "Your password",
                    placeholder: "••••••••••••",
                    text: $password,
                    isSecure: true
                )

                PrimaryButton(title: "NEXT STEP") {
                    print("login tapped")
                }
                .padding(.top, 20)

                HStack(spacing: 4) {
                    TypographyLabel(
                        text: "Don’t have an account?",
                        style: .body,
                        color: .black
                    )

                    TypographyLabel(
                        text: "Sign up",
                        style: .button,
                        color: .black
                    )
                }

                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    LoginView()
}
