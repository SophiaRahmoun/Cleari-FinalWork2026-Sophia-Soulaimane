//
//  UserProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        ZStack {
            DarkBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 34) {
                        ProfileHeader(
                            imageName: "ProfileSample",
                            fullName: "Anne Dupont",
                            username: "Annedupont",
                            memberSince: "2026"
                        )

                        VStack(spacing: 18) {
                            ProfileMenuSection(title: "Account")

                            ProfileMenuRow(title: "Edit profile")
                            ProfileMenuRow(title: "Subscription")

                            ProfileMenuSection(title: "My skin")

                            ProfileMenuRow(title: "Skin goals")
                            ProfileMenuRow(title: "My skin scans")

                            ProfileMenuSection(title: "Settings")

                            ProfileMenuRow(title: "Appointments")
                            ProfileMenuRow(title: "Privacy  & security")
                            ProfileMenuRow(title: "Help & support")
                            ProfileMenuRow(title: "Language")
                            ProfileMenuRow(title: "Notifications")
                            ProfileMenuRow(title: "Log out", isDestructive: true)
                        }
                        .padding(.horizontal, 34)
                    }
                    .padding(.top, 70)
                    .padding(.bottom, 35)
                }

                ScanBottomBar()
            }
        }
    }
}
