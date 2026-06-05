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

            verdictBadge

            Text(post.title)
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(Color(hex: "1A1018"))
                .lineLimit(2)

            if let imageUrl = post.imageUrl,
               let resolvedUrl = URL(string: imageUrl.hasPrefix("http") ? imageUrl : "\(APIConfig.baseHost)\(imageUrl)") {


                AsyncImage(url: URL(string: "\(APIConfig.baseHost)\(imageUrl)")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.white.opacity(0.25)
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            } else if let tiktokUrl = post.tiktokUrl, !tiktokUrl.isEmpty {

                TikTokLinkPreviewView(
                    urlString: tiktokUrl,
                    title: post.trendName
                )
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
                message: post.debunkExplanation,
                likesCount: post.likesCount ?? 0,
                isLiked: post.isLikedByCurrentUser ?? false,
                commentsCount: post.commentsCount ?? 0,
                onLikeTapped: onLikeTapped,
                onCommentTapped: onCommentTapped
            )
        }
        .padding(22)
        .background(Color("AccentColor").opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    @ViewBuilder
    private var verdictBadge: some View {
        switch post.status.lowercased() {
        case "true":
            Label("True", systemImage: "checkmark.seal.fill")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green)
                .clipShape(Capsule())

        case "use_with_caution", "use with caution":
            Label("Use with caution", systemImage: "exclamationmark.triangle.fill")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.yellow)
                .clipShape(Capsule())

        case "not_recommended", "not recommended":
            Label("Not recommended", systemImage: "xmark.seal.fill")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.red)
                .clipShape(Capsule())

        default:
            EmptyView()
        }
    }
}
