//
//  DermatologistCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct DermatologistCard: View {
    let imageName: String
    let name: String
    let description: String
    let city: String
    let rating: String

    var body: some View {
        HStack(spacing: 18) {
            AvatarView(imageName: imageName, size: 76)

            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(.white)

                Text(description)
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(.white.opacity(0.85))

                HStack(spacing: 28) {
                    Text(city)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        Text(rating)
                    }
                }
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "arrow.down.left")
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 22)
        .frame(height: 105)
        .background(Color(hex: "1A1018"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
