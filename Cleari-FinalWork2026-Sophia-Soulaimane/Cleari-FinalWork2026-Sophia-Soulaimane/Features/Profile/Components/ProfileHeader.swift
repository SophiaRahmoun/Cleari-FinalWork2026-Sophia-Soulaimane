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
        VStack(spacing: 14) {
            AvatarView(size: 110)

            Text(fullName)
                .font(AppFont.gillSwiftUI(.bold, size: 32))
                .foregroundColor(.white)

            Text(username)
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(.white.opacity(0.9))

            Text("Member since \(memberSince)")
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(.white.opacity(0.7))

            HStack {
                ProfileStat(number: "24", label: "Appointments")
                Spacer()
                ProfileStat(number: "3", label: "Appointments")
                Spacer()
                ProfileStat(number: "1", label: "Dermatologist")
            }
            .padding(.top, 10)
            .padding(.horizontal, 40) 
            .padding(.top, 8)
            .padding(.horizontal, 28)
        }
    }
}
