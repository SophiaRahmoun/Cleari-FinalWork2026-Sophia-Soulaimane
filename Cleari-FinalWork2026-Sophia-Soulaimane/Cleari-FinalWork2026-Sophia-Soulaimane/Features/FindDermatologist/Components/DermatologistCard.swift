//
//  DermatologistCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct DermatologistCard: View {
    let dermatologist: Dermatologist

    var body: some View {
        HStack(spacing: 18) {
            AvatarView(
                imageName: dermatologist.profileImage ?? "ProfileSample",
                size: 76
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(dermatologist.name)
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(.white)

                Text(dermatologist.description ?? "Skin specialist")
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(.white.opacity(0.85))

                HStack(spacing: 28) {
                    Text(dermatologist.city ?? "Brussels")

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", dermatologist.rating ?? 4.9))
                    }
                }
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "message.fill")
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 22)
        .frame(height: 105)
        .background(Color(hex: "1A1018"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
    }
}
