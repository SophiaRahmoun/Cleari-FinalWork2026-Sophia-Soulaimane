//
//  EditProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = "Anne Dupont"
    @State private var username = "annedupont"
    @State private var pronouns = "she/her"
    @State private var skinType = "Dry, Sensitive"

    private let email = "annedpnt98@gmail.com"

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

                PrimaryButton(title: "Done") {
                    print("Profile saved")
                    print("Name:", fullName)
                    print("Username:", username)
                    print("Pronouns:", pronouns)
                    print("Skin type:", skinType)
                }
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
            .padding(.top, 95)
        }
    }
}

extension EditProfileView {
    private var header: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(.white)
                }

                Spacer()
            }
        }
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
            EditProfileRow(title: "Name", value: fullName) {
                print("Edit name tapped")
            }

            EditProfileRow(title: "Username", value: username) {
                print("Edit username tapped")
            }

            EditProfileRow(title: "Pronouns", value: pronouns) {
                print("Edit pronouns tapped")
            }

            EditProfileRow(title: "Skin Type", value: skinType) {
                print("Edit skin type tapped")
            }

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
                print("Edit password tapped")
            }
        }
    }
}
