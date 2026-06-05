//
//  UserProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

private enum ProfileDestination: Identifiable {
    case payment, earnings, editProfile, privacy, skinGoals, appointments, scanHistory, routine
    var id: Int { hashValue }
}

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var destination: ProfileDestination? = nil
    @State private var showLogoutSheet = false

    private var isDermatologist: Bool {
        TokenStorage.shared.userRole == "dermatologist"
    }

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
                            imageUrl: viewModel.profilePictureUrl,
                            fullName: viewModel.fullName,
                            username: viewModel.username,
                            memberSince: viewModel.memberSince
                        )

                        VStack(spacing: 10) {

                            ProfileMenuSection(title: "Account")

                            Button {
                                destination = .editProfile
                            } label: {
                                ProfileMenuRow(title: "Edit profile")
                            }
                            .buttonStyle(.plain)

                            Button {
                                destination = isDermatologist ? .earnings : .payment
                            } label: {
                                ProfileMenuRow(title: "Subscription")
                            }
                            .buttonStyle(.plain)

                            if !isDermatologist {
                                ProfileMenuSection(title: "My skin")

                                Button {
                                    destination = .skinGoals
                                } label: {
                                    ProfileMenuRow(title: "Skin goals")
                                }
                                .buttonStyle(.plain)

                                Button {
                                    destination = .routine
                                } label: {
                                    ProfileMenuRow(title: "My routines")
                                }
                                .buttonStyle(.plain)

                                Button {
                                    destination = .scanHistory
                                } label: {
                                    ProfileMenuRow(title: "My skin scans")
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                destination = .appointments
                            } label: {
                                ProfileMenuRow(title: "Appointments")
                            }
                            .buttonStyle(.plain)

                            Button {
                                destination = .privacy
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
                // Profile is a standalone full-screen page — no bottom navigation bar here.
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
        .fullScreenCover(item: $destination) { dest in
            switch dest {
            case .payment:
                PayementView()
            case .earnings:
                DermatologistEarningsView()
            case .editProfile:
                EditProfileView()
                    .onDisappear {
                        Task { await viewModel.fetchCurrentUser() }
                    }
            case .privacy:
                PrivacyView()
            case .skinGoals:
                SkinGoalView()
            case .appointments:
                if isDermatologist {
                    DermatologistAppointmentRequestsView()
                } else {
                    MyAppointmentsView()
                }
            case .scanHistory:
                ScanHistoryView()
            case .routine:
                RoutineView()
            }
        }
    }
}
