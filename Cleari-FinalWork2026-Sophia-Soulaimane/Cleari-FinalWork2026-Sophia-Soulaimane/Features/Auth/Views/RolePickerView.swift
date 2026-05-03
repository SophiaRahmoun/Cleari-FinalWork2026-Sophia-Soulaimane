//
//  RolePickerView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct RolePickerView: View {
    var onContinue: (String) -> Void = { _ in }
    var onLogin: () -> Void = {}
    
    @State private var selectedRole: String = "User"

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

                PrimaryButton(title: "CONTINUE") {
                    onContinue(selectedRole)
                }
                .padding(.horizontal, 70)
                .padding(.top, 70)

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
