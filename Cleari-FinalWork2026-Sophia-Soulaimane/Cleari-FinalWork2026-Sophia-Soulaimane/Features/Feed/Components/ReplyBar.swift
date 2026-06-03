//
//  ReplyBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct ReplyBar: View {
    var onTap: (() -> Void)? = nil
    /// Optional current user profile picture URL (Cloudinary)
    var avatarUrl: String? = nil
    /// Optional current user username for initial placeholder
    var username: String? = nil

    private let dark  = Color(hex: "1A1018")
    private let beige = Color(hex: "FDF3EB")
    private let pink  = Color(hex: "C66F8C")

    var body: some View {
        HStack(spacing: 10) {
            // Current user avatar
            avatar

            // Tappable pill
            Button { onTap?() } label: {
                Text("Share your thoughts")
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(beige.opacity(0.55))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(dark)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var avatar: some View {
        if let urlString = avatarUrl, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if case .success(let img) = phase {
                    img.resizable().scaledToFill()
                } else {
                    initialPlaceholder
                }
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
        } else {
            initialPlaceholder
                .frame(width: 32, height: 32)
        }
    }

    private var initialPlaceholder: some View {
        Circle()
            .fill(pink.opacity(0.2))
            .overlay(
                Text(String((username ?? "?").prefix(1)).uppercased())
                    .font(AppFont.gillSwiftUI(.bold, size: 13))
                    .foregroundColor(pink)
            )
    }
}
