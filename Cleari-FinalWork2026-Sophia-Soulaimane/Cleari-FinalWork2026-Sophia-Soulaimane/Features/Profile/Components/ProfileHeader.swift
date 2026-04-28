//
//  ProfileHeader.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ProfileHeader: View {
    let imageName: String
    let fullName: String
    let username: String
    let memberSince: String

    var body: some View {
        VStack(spacing: 16) {

            // Avatar
            AvatarView(size: 110)
            // Name
            Text(fullName)
                .font(AppFont.gillSwiftUI(.bold, size: 32))
                .foregroundColor(.white)

            // Username
            Text(username)
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(.white.opacity(0.9))

            // Member since
            Text("Member since \(memberSince)")
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(.white.opacity(0.7))

            // Stats
            HStack(spacing: 40) {
                ProfileStat(number: "24", label: "Appointments")
                ProfileStat(number: "3", label: "Appointments")
                ProfileStat(number: "1", label: "Dermatologist")
            }
            .padding(.top, 10)
        }
    }
}
