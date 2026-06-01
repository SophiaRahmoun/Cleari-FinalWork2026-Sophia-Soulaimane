//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

// ─── One complete post unit (question + dermato card + actions) ───
private struct FeedItem: View {
    let username: String
    let timeAgo: String
    let question: String
    let doctorName: String
    let doctorReply: String
    var userAvatarUrl: String? = nil
    var doctorAvatarUrl: String? = nil
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var sharesCount: Int = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            UserQuestionRow(
                username: username,
                timeAgo: timeAgo,
                content: question,
                avatarUrl: userAvatarUrl
            )

            FeedPostCard(
                doctorName: doctorName,
                doctorAvatarUrl: doctorAvatarUrl,
                replyText: doctorReply
            )

            PostActionsRow(
                likesCount: likesCount,
                commentsCount: commentsCount,
                sharesCount: sharesCount
            )
        }
    }
}

// ─── Main feed ───
struct FeedView: View {
    private let dark  = Color(hex: "1A1018")
    private let beige = Color(hex: "FDF3EB")

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            // Scrollable content
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 32) {

                    FeedTopBar()

                    // ── Post 1 ──
                    FeedItem(
                        username: "jules.ctm",
                        timeAgo: "20h",
                        question: "Does applying iron to the body reduce wrinkles?",
                        doctorName: "Dr. Naak Mouloud",
                        doctorReply: "No applying heat like ironing, won't reduce wrinkles. In fact, it can irritate the skin and lead to burns or damage. Stick to proven skincare methods for anti-aging!",
                        likesCount: 30,
                        commentsCount: 14,
                        sharesCount: 1
                    )

                    // ── Post 2 ──
                    FeedItem(
                        username: "Sodapop",
                        timeAgo: "20h",
                        question: "I think I've seen something similar before but it seems risky to me.",
                        doctorName: "Dr. André Leduc",
                        doctorReply: "I've seen similar trends before. There's no solid scientific evidence behind it, and it could irritate or damage the skin. I wouldn't recommend trying this.",
                        likesCount: 30,
                        commentsCount: 14,
                        sharesCount: 1
                    )
                }
                .padding(.top, 8)
                .padding(.bottom, 180) // space for bottom bars
            }

            // ── Bottom sticky area ──
            VStack(spacing: 0) {
                // Separator
                Rectangle()
                    .fill(dark.opacity(0.12))
                    .frame(height: 1)

                // Reply bar
                ReplyBar(
                    avatarUrl: nil
                )
                .padding(.top, 4)

                // Nav bar
                ScanBottomBar()
            }
            .background(
                LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}

#Preview {
    FeedView()
}
