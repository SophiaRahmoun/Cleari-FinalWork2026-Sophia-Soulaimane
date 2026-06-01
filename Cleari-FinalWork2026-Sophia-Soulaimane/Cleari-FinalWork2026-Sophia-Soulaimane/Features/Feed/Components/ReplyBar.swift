//
//  ReplyBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct ReplyBar: View {
    var onTap: (() -> Void)? = nil
    var avatarUrl: String? = nil

    private let dark  = Color(hex: "1A1018")
    private let beige = Color(hex: "FDF3EB")

    var body: some View {
        HStack(spacing: 12) {
            // User avatar
            Group {
                if let url = avatarUrl.flatMap(URL.init) {
                    AsyncImage(url: url) { phase in
                        if case .success(let img) = phase {
                            img.resizable().scaledToFill()
                        } else {
                            placeholderAvatar
                        }
                    }
                } else {
                    placeholderAvatar
                }
            }
            .frame(width: 38, height: 38)
            .clipShape(Circle())

            // Reply pill
            Button {
                onTap?()
            } label: {
                Text("Post your reply")
                    .font(AppFont.gillSwiftUI(.regular, size: 15))
                    .foregroundColor(beige.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 11)
                    .background(dark)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    private var placeholderAvatar: some View {
        Circle()
            .fill(dark.opacity(0.15))
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(dark.opacity(0.4))
                    .font(.system(size: 16))
            )
    }
}

#Preview {
    ZStack {
        LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9").ignoresSafeArea()
        ReplyBar()
    }
}
