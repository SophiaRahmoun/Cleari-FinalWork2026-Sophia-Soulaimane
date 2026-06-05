//
//  ProfileHeader.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ProfileHeader: View {
    var imageUrl: String? = nil
    let fullName: String
    let username: String
    let memberSince: String

    var body: some View {
        VStack(spacing: 14) {
            AvatarView(imageUrl: imageUrl, size: 110)

            Text(fullName)
                .font(AppFont.gillSwiftUI(.bold, size: 32))
                .foregroundColor(.white)

            Text(username)
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(.white.opacity(0.9))

            Text("Member since \(memberSince)")
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(.white.opacity(0.7))

        }
    }
}
