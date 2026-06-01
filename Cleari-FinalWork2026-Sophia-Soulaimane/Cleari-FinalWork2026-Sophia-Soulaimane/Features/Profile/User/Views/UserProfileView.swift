//
//  UserProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPayementView = false
    @State private var showEditProfileView = false
    @State private var showLogoutSheet = false
    @State private var showPrivacyView = false

    @StateObject private var viewModel = UserProfileViewModel()

    var body: some View {

        ZStack {

            DarkBackground()

            VStack(spacing: 0) {

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
                .padding(.horizontal, 28)
                .padding(.top, 20)

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 32) {

                        ProfileHeader(
                            imageName: "ProfileSample",
                            fullName: viewModel.fullName,
                            username: viewModel.username,
                            memberSince: viewModel.memberSince
                        )

                        VStack(spacing: 10) {

                            ProfileMenuSection(title: "Account")

                            Button {
                                showEditProfileView = true
                            } label: {
                                ProfileMenuRow(title: "Edit profile")
                            }
                            .buttonStyle(.plain)

                            Button {

                                if TokenStorage.shared.userRole != "dermatologist" {
                                    showPayementView = true
                                }

                            } label: {
                                ProfileMenuRow(title: "Subscription")
                            }
                            .buttonStyle(.plain)

                            ProfileMenuSection(title: "My skin")

                            ProfileMenuRow(title: "Skin goals")
                            ProfileMenuRow(title: "My skin scans")

                            ProfileMenuRow(title: "Appointments")
                            Button {

                                showPrivacyView = true

                            } label: {

                                ProfileMenuRow(title: "Privacy  & security")
                            }
                            .buttonStyle(.plain)
                            ProfileMenuSection(title: "Settings")


                            Button {
                                showLogoutSheet = true
                            } label: {
                                ProfileMenuRow(
                                    title: "Log out",
                                    isDestructive: true
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 35)
                }

                ScanBottomBar()
            }

            if showLogoutSheet {

                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showLogoutSheet = false
                    }

                LogoutConfirmationView {

                    showLogoutSheet = false

                    TokenStorage.shared.clear()

                    dismiss()

                } onCancelTapped: {

                    showLogoutSheet = false
                }
                .padding(.horizontal, 28)
            }
        }
        .task {
            await viewModel.fetchCurrentUser()
        }
        .fullScreenCover(isPresented: $showPayementView) {

            PayementView()
        }
        .fullScreenCover(isPresented: $showEditProfileView, onDismiss: {

            Task {
                await viewModel.fetchCurrentUser()
            }

        }) {

            EditProfileView()
        }
        .fullScreenCover(isPresented: $showPrivacyView) {

            PrivacyView()
        }
    }
}
