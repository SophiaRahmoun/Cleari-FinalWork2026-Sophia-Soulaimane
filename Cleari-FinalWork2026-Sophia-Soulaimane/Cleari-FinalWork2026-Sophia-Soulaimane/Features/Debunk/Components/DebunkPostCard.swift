//
//  DebunkPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct DebunkPostCard: View {
    let title: String
    let mediaName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(AppFont.gillSwiftUI(.bold, size: 22))
                .foregroundColor(Color(hex: "1A1018"))
                .lineLimit(2)

            Image(mediaName)
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            DebunkExpertReplyCard(
                imageName: "ProfileSample",
                name: "Dr. Sarah Ben Ali",
                role: "Dermatologist",
                message: "This trend is risky and not supported by science.\nHeat can damage the skin barrier and cause burns."
            )
        }
        .padding(22)
        .background(Color("AccentColor").opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
