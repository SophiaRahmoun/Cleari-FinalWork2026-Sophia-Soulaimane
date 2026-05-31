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
                            fullName: "Anne Dupont",
                            username: "Annedupont",
                            memberSince: "2026"
                        )

                        VStack(spacing: 10) {

                            ProfileMenuSection(title: "Account")
                            ProfileMenuRow(title: "Edit profile")

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
                            ProfileMenuSection(title: "Settings")
                            ProfileMenuRow(title: "Appointments")
                            ProfileMenuRow(title: "Privacy  & security")
                            ProfileMenuRow(title: "Help & support")
                            ProfileMenuRow(title: "Language")
                            ProfileMenuRow(title: "Notifications")
                            ProfileMenuRow(
                                title: "Log out",
                                isDestructive: true
                            )
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 35)
                }
                ScanBottomBar()
            }
        }
        .fullScreenCover(isPresented: $showPayementView) {

            PayementView()
        }
    }
}
