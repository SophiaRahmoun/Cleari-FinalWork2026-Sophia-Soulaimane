//
//  EditProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var pronouns = "she/her"
    @State private var skinType = ""
    @State private var isLoading = false
    @State private var successMessage: String?
    @State private var errorMessage: String?
    @State private var showChangePasswordView = false


    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header

                profilePictureSection
                    .padding(.top, 55)

                profileInfoSection
                    .padding(.top, 70)

                Spacer()
                    .frame(height: 30)
                
                if let successMessage {
                    Text(successMessage)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                PrimaryButton(title: "Done") {
                    Task {
                        do {

                            try await UserProfileService.shared.updateUsername(
                                username: username
                            )

                            let message = try await UserProfileService.shared.updatePronouns(
                                pronouns: pronouns
                            )

                            successMessage = message
                            errorMessage = nil

                            try await Task.sleep(nanoseconds: 800_000_000)
                            dismiss()

                        } catch {

                            successMessage = nil

                            if error.localizedDescription.contains("Username already exists") {
                                errorMessage = "Username already taken"
                            } else {
                                errorMessage = "Could not update profile"
                            }
                        }
                    }
                }
                .padding(.horizontal, 34)
                /*PrimaryButton(title: "Done") {
                    print("Profile saved")
                    print("Name:", fullName)
                    print("Username:", username)
                    print("Pronouns:", pronouns)
                    print("Skin type:", skinType)
                }
                 */
                .padding(.horizontal, 34)

                Button {
                    print("Switch to dermatologist account tapped")
                } label: {
                    Text("Switch to dermatologist account")
                        .font(AppFont.gillSwiftUI(.regular, size: 24))
                        .foregroundColor(Color(hex: "1A1018"))
                }
                .buttonStyle(.plain)
                .padding(.top, 85)
                .padding(.bottom, 45)
            }
            .padding(.horizontal, 34)
            .padding(.top, 40)
        }
        .task {
            await loadProfile()
        }
        .fullScreenCover(isPresented: $showChangePasswordView) {
            ChangePasswordView()
        }
    }

    private func loadProfile() async {
        isLoading = true

        do {
            let user = try await UserProfileService.shared.fetchCurrentUser()

            let firstName = user.firstName ?? ""
            let lastName = user.lastName ?? ""

            skinType = user.skinType ?? ""
            pronouns = user.pronouns ?? ""

            fullName = "\(firstName) \(lastName)"
                .trimmingCharacters(in: .whitespaces)

            username = user.username
            email = user.email

        } catch {
            print("EDIT PROFILE LOAD ERROR:", error.localizedDescription)
        }

        isLoading = false
    }
}

extension EditProfileView {
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(.top, 20)
    }

    private var profilePictureSection: some View {
        VStack(spacing: 22) {
            Circle()
                .fill(Color.white.opacity(0.35))
                .frame(width: 155, height: 155)

            Button {
                print("Edit picture tapped")
            } label: {
                Text("Edit picture")
                    .font(AppFont.gillSwiftUI(.bold, size: 24))
                    .foregroundColor(Color(hex: "1A1018"))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }

    private var profileInfoSection: some View {
        VStack(spacing: 30) {
            EditProfileRow(title: "Name", value: fullName)

            HStack {
                Text("Username")
                    .font(AppFont.gillSwiftUI(.regular, size: 18))
                    .foregroundColor(Color(hex: "1A1018"))

                Spacer()

                TextField("Username", text: $username)
                    .multilineTextAlignment(.trailing)
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(Color(hex: "1A1018").opacity(0.45))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }

            pronounsRow

            EditProfileRow(
                title: "Skin Type",
                value: skinType.isEmpty ? "Not completed" : skinType
            )
            Spacer()
                .frame(height: 15)

            EditProfileRow(
                title: "E-mail",
                value: email,
                isDisabled: true
            )

            EditProfileRow(
                title: "Password",
                value: "",
                showChevron: true
            ) {
                showChangePasswordView = true
            }
        }
    }

    private var pronounsRow: some View {
        HStack {
            Text("Pronouns")
                .font(AppFont.gillSwiftUI(.regular, size: 18))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()

            HStack(spacing: 8) {
                pronounButton("she/her")
                pronounButton("he/him")
            }
        }
    }

    private func pronounButton(_ value: String) -> some View {
        Button {
            pronouns = value
        } label: {
            Text(value)
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(pronouns == value ? .white : Color(hex: "1A1018"))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(pronouns == value ? Color(hex: "1A1018") : Color.white.opacity(0.55))
                )
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "1A1018"), lineWidth: 1.2)
                )
        }
        .buttonStyle(.plain)
    }
}
