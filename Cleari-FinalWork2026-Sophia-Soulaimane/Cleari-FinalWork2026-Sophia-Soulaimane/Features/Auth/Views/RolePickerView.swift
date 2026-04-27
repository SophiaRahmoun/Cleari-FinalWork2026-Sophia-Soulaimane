//
//  RolePickerView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct RolePickerView: View {
    @State private var selectedRole = "Dermatologist"

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(spacing: 0) {
                TypographyLabel(
                    text: "Register as",
                    style: .h1Italic,
                    color: .black
                )
                .padding(.top, 70)

                Spacer()

                TypographyLabel(
                    text: "As a user, you can learn to understand your skin better, avoid misinformation, scan your skin for insights, and easily connect with dermatologists when needed",
                    style: .body,
                    color: .black
                )
                .padding(.horizontal, 32)

                HStack(spacing: 70) {
                    roleButton(title: "User")
                    roleButton(title: "Dermatologist")
                }
                .padding(.top, 90)

                PrimaryButton(title: "CONTINUE") {
                    print("Continue as \(selectedRole)")
                }
                .padding(.horizontal, 70)
                .padding(.top, 70)

                HStack(spacing: 4) {
                    TypographyLabel(
                        text: "already have an account?",
                        style: .caption,
                        color: .black
                    )

                    TypographyLabel(
                        text: "Login",
                        style: .caption,
                        color: .black
                    )
                }
                .padding(.top, 80)

                Spacer()
            }
        }
    }

    private func roleButton(title: String) -> some View {
        Button {
            selectedRole = title
        } label: {
            TypographyLabel(
                text: title,
                style: .button,
                color: .black
            )
            .overlay(alignment: .bottom) {
                if selectedRole == title {
                    Rectangle()
                        .frame(height: 1.5)
                        .offset(y: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RolePickerView()
}
