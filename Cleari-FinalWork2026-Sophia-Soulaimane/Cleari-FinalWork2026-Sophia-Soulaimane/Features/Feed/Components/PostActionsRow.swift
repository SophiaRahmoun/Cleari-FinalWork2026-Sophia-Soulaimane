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
        HStack(spacing: 32) {
            Button {
                onLikeTapped()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? pink : dark)
                    Text("\(likesCount)")
                        .foregroundColor(dark)
                }
            }
            .buttonStyle(.plain)

            Button {
                onCommentTapped()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                    Text("\(commentsCount)")
                }
                .foregroundColor(dark)
            }
            .buttonStyle(.plain)

            HStack(spacing: 6) {
                Image(systemName: "arrowshape.turn.up.right")
                Text("0")
            }
            .foregroundColor(dark)

            Spacer()
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
    }
}
