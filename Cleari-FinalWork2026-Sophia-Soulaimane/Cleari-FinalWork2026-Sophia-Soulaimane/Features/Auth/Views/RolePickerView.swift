//
//  RolePickerView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct RolePickerView: View {
    @State private var selectedRole: String = "User"

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(spacing: 0) {

                // Title
                TypographyLabel(
                    text: "Register as",
                    style: .h1Italic,
                    color: .black
                )
                .padding(.top, 70)

                Spacer()

                // Description
                TypographyLabel(
                    text: "As a user, you can learn to understand your skin better, avoid misinformation, scan your skin for insights, and easily connect with dermatologists when needed",
                    style: .body,
                    color: .black
                )
                .padding(.horizontal, 32)

                // ROLE BUTTONS
                HStack(spacing: 70) {
                    AuthRoleButton(
                        title: "User",
                        isSelected: selectedRole == "User"
                    ) {
                        selectedRole = "User"
                    }

                    AuthRoleButton(
                        title: "Dermatologist",
                        isSelected: selectedRole == "Dermatologist"
                    ) {
                        selectedRole = "Dermatologist"
                    }
                }
                .padding(.top, 90)

                // Continue button
                PrimaryButton(title: "CONTINUE") {
                    print("Selected role: \(selectedRole)")
                }
                .padding(.horizontal, 70)
                .padding(.top, 70)

                // Bottom link
                AuthBottomLink(
                    text: "already have an account?",
                    linkText: "Login"
                )
                .padding(.top, 80)

                Spacer()
            }
        }
    }
}

#Preview {
    RolePickerView()
}
