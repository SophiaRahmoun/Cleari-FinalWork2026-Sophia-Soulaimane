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

    var body: some View {
        HStack(spacing: 32) {
            Button {
                onLikeTapped()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                    Text("\(likesCount)")
                }
            }
            .buttonStyle(.plain)

            HStack(spacing: 6) {
                Image(systemName: "bubble.right")
                Text("0")
            }

            HStack(spacing: 6) {
                Image(systemName: "arrowshape.turn.up.right")
                Text("0")
            }

            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(Color(hex: "1A1018"))
        .padding(.horizontal, 16)
    }
}
