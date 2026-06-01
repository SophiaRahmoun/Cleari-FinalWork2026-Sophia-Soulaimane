//
//  FeedPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedPostCard: View {
    let doctorName: String
    let doctorAvatarUrl: String?
    let replyText: String
    var isVerified: Bool = true

    private let dark  = Color(hex: "1A1018")
    private let beige = Color(hex: "FDF3EB")

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Doctor header ──
            HStack(spacing: 12) {
                // Avatar
                Group {
                    if let url = doctorAvatarUrl.flatMap(URL.init) {
                        AsyncImage(url: url) { phase in
                            if case .success(let img) = phase {
                                img.resizable().scaledToFill()
                            } else {
                                avatarPlaceholder
                            }
                        }
                    } else {
                        avatarPlaceholder
                    }
                }
                .frame(width: 42, height: 42)
                .clipShape(Circle())

                // Name + role
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(doctorName)
                            .font(AppFont.gillSwiftUI(.bold, size: 15))
                            .foregroundColor(dark)

                        if isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "6BC7A8"))
                        }
                    }

                    Text("Dermatologist")
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(dark.opacity(0.5))
                }

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)

            // ── Divider ──
            Rectangle()
                .fill(dark.opacity(0.08))
                .frame(height: 1)
                .padding(.horizontal, 18)

            // ── Reply text ──
            Text(replyText)
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(dark)
                .lineSpacing(4)
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
        }
        .background(beige)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 24)
    }

    private var avatarPlaceholder: some View {
        Circle()
            .fill(dark.opacity(0.12))
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(dark.opacity(0.4))
                    .font(.system(size: 18))
            )
    }
}

#Preview {
    ZStack {
        LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9").ignoresSafeArea()
        FeedPostCard(
            doctorName: "Dr. Naak Mouloud",
            doctorAvatarUrl: nil,
            replyText: "No applying heat like ironing, won't reduce wrinkles. In fact, it can irritate the skin and lead to burns or damage. Stick to proven skincare methods for anti-aging!"
        )
    }
}
