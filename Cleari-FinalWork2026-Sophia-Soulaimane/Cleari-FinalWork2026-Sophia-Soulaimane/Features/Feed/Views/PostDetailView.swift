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

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    FeedPostCard(
                        post: post,
                        onLikeTapped: {
                        },
                        onCommentTapped: {
                        }
                    )

                    Divider()
                        .background(Color(hex: "1A1018").opacity(0.35))

                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else {
                        ForEach(comments) { comment in
                            commentRow(comment)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 150)
            }

            bottomReplyBar
        }
        .task {
            await fetchComments()
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            Spacer()

            Text("Post")
                .font(AppFont.gillSwiftUI(.bold, size: 24))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()

            Color.clear
                .frame(width: 26, height: 26)
        }
        .padding(.horizontal, 20)
    }

    private func commentRow(_ comment: CommunityPostComment) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 38, height: 38)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(comment.User.username)
                        .font(AppFont.gillSwiftUI(.bold, size: 16))
                        .foregroundColor(Color(hex: "1A1018"))

                    Text("· now")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.gray)
                }

                Text(comment.content)
                    .font(AppFont.gillSwiftUI(.regular, size: 17))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    private var bottomReplyBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "1A1018").opacity(0.35))
                .frame(height: 1)

            HStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.gray)

                TextField("Post your reply", text: $commentText)
                    .font(AppFont.gillSwiftUI(.regular, size: 15))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(Color(hex: "1A1018"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                Button(isSending ? "..." : "Reply") {
                    Task {
                        await createComment()
                    }
                }
                .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                .font(AppFont.gillSwiftUI(.bold, size: 14))
                .foregroundColor(Color(hex: "1A1018"))
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 34)
        }
        .background(
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea(edges: .bottom)
        )
    }

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
            try await CommunityPostService.shared.createComment(
                postId: post.id,
                content: commentText
            )

            commentText = ""
            comments = try await CommunityPostService.shared.fetchComments(postId: post.id)
        } catch {
            print("ERROR CREATING COMMENT:", error.localizedDescription)
        }

        isSending = false
    }
}
