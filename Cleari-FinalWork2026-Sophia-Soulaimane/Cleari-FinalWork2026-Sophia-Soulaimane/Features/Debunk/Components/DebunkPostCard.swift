//
//  DebunkPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct DebunkPostCard: View {
    let post: FakeTrendPost
    let onLikeTapped: () -> Void
    let onCommentTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            Text(post.title)
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(Color(hex: "1A1018"))
                .lineLimit(2)

            if let imageUrl = post.imageUrl {

                AsyncImage(url: URL(string: "http://localhost:4000\(imageUrl)")) { image in

                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {
                    Color.white.opacity(0.25)
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            } else {

                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.25))
                    .frame(height: 220)
                    .overlay {

                        Text(post.trendName)
                            .font(AppFont.gillSwiftUI(.bold, size: 22))
                            .foregroundColor(Color(hex: "1A1018"))
                    }
            }

            DebunkExpertReplyCard(
                imageName: "ProfileSample",
                name: post.dermatologist?.username ?? "Dermatologist",
                role: "Dermatologist",
                message: post.debunkExplanation
            )

            HStack(spacing: 18) {

                Button {
                    onLikeTapped()
                } label: {

                    HStack(spacing: 6) {

                        Image(systemName: (post.isLikedByCurrentUser ?? false) ? "heart.fill" : "heart")

                        Text("\(post.likesCount ?? 0)")
                    }
                }
                .buttonStyle(.plain)

                Button {
                    onCommentTapped()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.right")
                        Text("\(post.commentsCount ?? 0)")
                    }
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(Color(hex: "1A1018"))
        }
        .padding(22)
        .background(Color("AccentColor").opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
