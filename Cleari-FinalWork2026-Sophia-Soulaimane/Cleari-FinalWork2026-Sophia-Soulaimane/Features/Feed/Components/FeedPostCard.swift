//
//  FeedPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedPostCard: View {
    let post: CommunityPost
    let onLikeTapped: () -> Void
    let onCommentTapped: () -> Void

    private let dark  = Color(hex: "1A1018")
    private let beige = Color(hex: "FDF3EB")
    private let pink  = Color(hex: "C66F8C")

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Header : avatar + username + time ──
            HStack(alignment: .center, spacing: 10) {
                userAvatar(username: post.User.username, imageUrl: post.User.profilePictureUrl, size: 34)

                HStack(spacing: 5) {
                    Text(post.User.username)
                        .font(AppFont.gillSwiftUI(.bold, size: 15))
                        .foregroundColor(dark)

                    Text("· \(timeAgo(from: post.createdAt))")
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(dark.opacity(0.45))
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 10)

            // ── Content ──
            Text(post.content)
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(dark)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                .padding(.bottom, post.imageUrl != nil ? 12 : 0)

            // ── Image (if any) ──
            if let imageUrl = post.imageUrl,
               let url = URL(string: imageUrl.hasPrefix("http") ? imageUrl : "\(APIConfig.baseHost)\(imageUrl)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        RoundedRectangle(cornerRadius: 14)
                            .fill(beige.opacity(0.5))
                            .overlay(ProgressView())
                    }
                }
                .frame(height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }

            // ── Actions ──
            PostActionsRow(
                likesCount: post.likesCount ?? 0,
                isLiked: post.isLikedByCurrentUser ?? false,
                onLikeTapped: onLikeTapped,
                commentsCount: post.commentsCount ?? 0,
                onCommentTapped: onCommentTapped
            )
            .padding(.bottom, 16)

            // ── Bottom separator ──
            Rectangle()
                .fill(dark.opacity(0.06))
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Avatar helper
    // Shows profile picture if URL exists, otherwise shows initial letter
    @ViewBuilder
    private func userAvatar(username: String, imageUrl: String?, size: CGFloat) -> some View {
        if let urlString = imageUrl, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if case .success(let img) = phase {
                    img.resizable().scaledToFill()
                } else {
                    initialCircle(username: username, size: size)
                }
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
        } else {
            initialCircle(username: username, size: size)
        }
    }

    private func initialCircle(username: String, size: CGFloat) -> some View {
        Circle()
            .fill(pink.opacity(0.18))
            .frame(width: size, height: size)
            .overlay(
                Text(String(username.prefix(1)).uppercased())
                    .font(AppFont.gillSwiftUI(.bold, size: size * 0.42))
                    .foregroundColor(pink)
            )
    }

    // MARK: - Time helper
    private func timeAgo(from isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: isoString) else { return "now" }
        let diff = Date().timeIntervalSince(date)
        switch diff {
        case ..<60:    return "now"
        case ..<3600:  return "\(Int(diff / 60))m"
        case ..<86400: return "\(Int(diff / 3600))h"
        default:       return "\(Int(diff / 86400))d"
        }
    }
}
