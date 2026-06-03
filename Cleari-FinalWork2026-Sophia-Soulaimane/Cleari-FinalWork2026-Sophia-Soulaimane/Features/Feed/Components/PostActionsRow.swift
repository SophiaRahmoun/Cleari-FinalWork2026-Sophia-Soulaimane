//
//  PostActionsRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct PostActionsRow: View {
    let likesCount: Int
    let isLiked: Bool
    let onLikeTapped: () -> Void
    let commentsCount: Int
    let onCommentTapped: () -> Void

    private let dark = Color(hex: "1A1018")
    private let pink = Color(hex: "C66F8C")

    var body: some View {
        HStack(spacing: 22) {
            // Like
            Button { onLikeTapped() } label: {
                HStack(spacing: 5) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 15))
                        .foregroundColor(isLiked ? pink : dark.opacity(0.6))
                    Text("\(likesCount)")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(dark.opacity(0.65))
                }
            }
            .buttonStyle(.plain)

            // Comment
            Button { onCommentTapped() } label: {
                HStack(spacing: 5) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 15))
                        .foregroundColor(dark.opacity(0.6))
                    Text("\(commentsCount)")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(dark.opacity(0.65))
                }
            }
            .buttonStyle(.plain)

            // Share (static)
            HStack(spacing: 5) {
                Image(systemName: "arrowshape.turn.up.right")
                    .font(.system(size: 15))
                    .foregroundColor(dark.opacity(0.6))
                Text("0")
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(dark.opacity(0.65))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}
