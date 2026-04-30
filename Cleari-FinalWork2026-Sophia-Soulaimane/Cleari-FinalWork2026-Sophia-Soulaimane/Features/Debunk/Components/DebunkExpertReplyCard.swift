//
//  DebunkExpertReplyCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct DebunkExpertReplyCard: View {
    let imageName: String
    let name: String
    let role: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                AvatarView(imageName: imageName, size: 38)

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(AppFont.gillSwiftUI(.regular, size: 20))
                        .foregroundColor(Color(hex: "1A1018"))

                    Text(role)
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(Color(hex: "1A1018"))
                }

                Spacer()
            }

            Text(message)
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(Color(hex: "1A1018"))
                .lineSpacing(3)

            HStack(spacing: 28) {
                Label("30", systemImage: "heart")
                Label("14", systemImage: "bubble.right")
                Label("1", systemImage: "square.and.arrow.up")
            }
            .font(AppFont.gillSwiftUI(.bold, size: 14))
            .foregroundColor(Color(hex: "1A1018"))
        }
        .padding(18)
        .background(Color.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 6)
    }
}
