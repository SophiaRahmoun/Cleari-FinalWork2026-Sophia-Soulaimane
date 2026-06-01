//
//  PostActionsRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct PostActionsRow: View {
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var sharesCount: Int = 0
    var isLiked: Bool = false
    var onLikeTapped: (() -> Void)? = nil
    var onCommentTapped: (() -> Void)? = nil

    private let dark = Color(hex: "1A1018")

    var body: some View {
        HStack(spacing: 28) {
            // Like
            Button {
                onLikeTapped?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(isLiked ? Color(hex: "C66F8C") : dark)
                    Text("\(likesCount)")
                        .font(AppFont.gillSwiftUI(.regular, size: 15))
                        .foregroundColor(dark)
                }
            }
            .buttonStyle(.plain)

            // Comment
            Button {
                onCommentTapped?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 17))
                        .foregroundColor(dark)
                    Text("\(commentsCount)")
                        .font(AppFont.gillSwiftUI(.regular, size: 15))
                        .foregroundColor(dark)
                }
            }
            .buttonStyle(.plain)

            // Share
            HStack(spacing: 6) {
                Image(systemName: "arrowshape.turn.up.right")
                    .font(.system(size: 17))
                    .foregroundColor(dark)
                Text("\(sharesCount)")
                    .font(AppFont.gillSwiftUI(.regular, size: 15))
                    .foregroundColor(dark)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9").ignoresSafeArea()
        PostActionsRow(likesCount: 30, commentsCount: 14, sharesCount: 1)
    }
}
