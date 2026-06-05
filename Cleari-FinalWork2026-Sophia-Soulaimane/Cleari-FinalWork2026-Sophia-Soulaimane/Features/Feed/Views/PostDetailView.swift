//
//  PostDetailView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 20/05/2026.
//

import SwiftUI

struct PostDetailView: View {
    let post: CommunityPost

    @Environment(\.dismiss) private var dismiss
    @State private var comments: [CommunityPostComment] = []
    @State private var commentText = ""
    @State private var isLoading = false
    @State private var isSending = false

    private let dark  = Color(hex: "1A1018")
    private let beige = Color(hex: "FDF3EB")
    private let pink  = Color(hex: "C66F8C")

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    header

                    FeedPostCard(
                        post: post,
                        onLikeTapped: {},
                        onCommentTapped: {}
                    )
                    .padding(.top, 8)

                    // ── Comments section header ──
                    HStack {
                        Text("Comments")
                            .font(AppFont.gillSwiftUI(.bold, size: 15))
                            .foregroundColor(dark.opacity(0.55))
                        Spacer()
                        if !comments.isEmpty {
                            Text("\(comments.count)")
                                .font(AppFont.gillSwiftUI(.regular, size: 13))
                                .foregroundColor(dark.opacity(0.4))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                    Rectangle()
                        .fill(dark.opacity(0.06))
                        .frame(height: 1)
                        .padding(.horizontal, 20)

                    if isLoading {
                        ProgressView()
                            .tint(dark)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else if comments.isEmpty {
                        Text("Be the first to comment.")
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(dark.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 32)
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(comments) { comment in
                                commentRow(comment)
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 130)
            }

            bottomReplyBar
        }
        .task { await fetchComments() }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(dark)
            }

            Spacer()

            Text("Post")
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(dark)

            Spacer()

            Color.clear.frame(width: 22, height: 22)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 4)
    }

    // MARK: - Comment row

    private func commentRow(_ comment: CommunityPostComment) -> some View {
        HStack(alignment: .top, spacing: 10) {
            // Avatar with initial
            initialCircle(username: comment.User.username, size: 30)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(comment.User.username)
                        .font(AppFont.gillSwiftUI(.bold, size: 14))
                        .foregroundColor(dark)
                    Text("· now")
                        .font(AppFont.gillSwiftUI(.regular, size: 12))
                        .foregroundColor(dark.opacity(0.4))
                }
                Text(comment.content)
                    .font(AppFont.gillSwiftUI(.regular, size: 15))
                    .foregroundColor(dark)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)

        // Divider between comments
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(dark.opacity(0.05))
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Bottom reply bar

    private var bottomReplyBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(dark.opacity(0.12))
                .frame(height: 1)

            HStack(spacing: 10) {
                // Current user placeholder
                initialCircle(username: "?", size: 30)

                TextField("", text: $commentText, prompt:
                    Text("Share your thoughts")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(beige.opacity(0.5))
                )
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(beige)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(dark)
                .clipShape(Capsule())

                Button {
                    Task { await createComment() }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(beige)
                        .padding(9)
                        .background(pink)
                        .clipShape(Circle())
                }
                .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 34)
        }
        .background(
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea(edges: .bottom)
        )
    }

    // MARK: - Avatar helper

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

    // MARK: - Data

    private func fetchComments() async {
        isLoading = true
        do {
            comments = try await CommunityPostService.shared.fetchComments(postId: post.id)
        } catch {
            print("ERROR FETCHING COMMENTS:", error.localizedDescription)
        }
        isLoading = false
    }

    private func createComment() async {
        isSending = true
        do {
            try await CommunityPostService.shared.createComment(postId: post.id, content: commentText)
            commentText = ""
            comments = try await CommunityPostService.shared.fetchComments(postId: post.id)
        } catch {
            print("ERROR CREATING COMMENT:", error.localizedDescription)
        }
        isSending = false
    }
}
