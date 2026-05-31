//
//  ProfileAvatarView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import SwiftUI

struct ProfileAvatarView: View {
    let imageName: String
    let size: CGFloat
    let action: () -> Void

    private let beige = Color(hex: "FDF3EB")
    private let darkBrown = Color(hex: "1E141D")

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(beige, lineWidth: 2)
                )
                .shadow(color: darkBrown.opacity(0.18), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
