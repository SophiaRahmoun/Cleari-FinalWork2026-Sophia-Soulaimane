//
//  ChangePasswordView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 31/05/2026.
//

import SwiftUI

struct ChangePasswordView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    @State private var isLoading = false
    @State private var successMessage: String?
    @State private var errorMessage: String?

    var body: some View {

        ZStack {

            RadialGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(spacing: 18) {

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(12)
                        }

                        Spacer()
                    }
                    .padding(.top, 20)

                    TypographyLabel(
                        text: "Change password",
                        style: .h1Italic,
                        color: .black
                    )
                    .padding(.top, 5)

                    VStack(spacing: 16) {
                        AuthRegisterInput(
                            label: "Old password",
                            text: $currentPassword,
                            maxLength: 25,
                            isSecure: true
                        )

                        AuthRegisterInput(
                            label: "New password",
                            text: $newPassword,
                            maxLength: 25,
                            isSecure: true
                        )

                        AuthRegisterInput(
                            label: "Repeat new password",
                            text: $confirmPassword,
                            maxLength: 25,
                            isSecure: true
                        )
                    }
                    .padding(.horizontal, 8)

                    if let successMessage {
                        Text(successMessage)
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    PrimaryButton(title: isLoading ? "LOADING..." : "DONE") {
                        Task {
                            await updatePassword()
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 8)

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 32)
            }
        }
    }

    private func updatePassword() async {

        isLoading = true
        successMessage = nil
        errorMessage = nil

        do {

            let message = try await UserProfileService.shared.updatePassword(
                currentPassword: currentPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            )

            successMessage = message
            errorMessage = nil

            try await Task.sleep(nanoseconds: 900_000_000)

            dismiss()

        } catch {

            successMessage = nil

            if error.localizedDescription.contains("Current password is incorrect") {
                errorMessage = "Current password is incorrect"
            } else if error.localizedDescription.contains("Passwords do not match") {
                errorMessage = "Passwords do not match"
            } else if error.localizedDescription.contains("Password must be at least 8 characters") {
                errorMessage = "Password must be at least 8 characters"
            } else {
                errorMessage = "Could not update password"
            }
        }

        isLoading = false
    }
}
