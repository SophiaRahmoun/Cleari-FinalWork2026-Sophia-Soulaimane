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

            AvatarView(imageUrl: dermatologist.profileImageUrl, size: 52)

            VStack(alignment: .leading, spacing: 8) {
                Text(dermatologist.displayName)
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(.white)

                Text(dermatologist.bio ?? dermatologist.specialization ?? "Skin specialist")
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)

                HStack(spacing: 28) {
                    if let city = dermatologist.city {
                        Text(city)
                    } else {
                        Text("Brussels")
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        Text("Verified")
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
