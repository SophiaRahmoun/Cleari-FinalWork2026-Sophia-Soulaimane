//
//  DebunkDetailView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct DebunkDetailView: View {
    let post: FakeTrendPost

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DebunkDetailViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        DebunkPostCard(
                            post: post,
                            onLikeTapped: {}
                            onCommentTapped: {}
                        )

                        Divider()
                            .background(Color(hex: "1A1018").opacity(0.35))

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.top, 30)
                        } else {
                            ForEach(viewModel.comments) { comment in
                                commentRow(comment)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 140)
                }
            }

            commentBar
        }
        .task {
            await viewModel.fetchComments(postId: post.id)
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            Spacer()

            Text("Post")
                .font(AppFont.gillSwiftUI(.bold, size: 28))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()

            Color.clear
                .frame(width: 28, height: 28)
        }
        .padding(.horizontal, 24)
        .padding(.top, 55)
        .padding(.bottom, 20)
    }

    private func commentRow(_ comment: FakeTrendComment) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 42, height: 42)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(comment.User.username)
                        .font(AppFont.gillSwiftUI(.bold, size: 16))

                    Text("· now")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.gray)
                }

                Text(comment.content)
                    .font(AppFont.gillSwiftUI(.regular, size: 17))
            }
            .foregroundColor(Color(hex: "1A1018"))

            Spacer()
        }
    }

    private var commentBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 42, height: 42)
                .foregroundColor(.gray)

            TextField("Post your reply", text: $viewModel.commentText)
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .padding(.horizontal, 18)
                .frame(height: 46)
                .background(Color(hex: "1A1018"))
                .foregroundColor(.white)
                .clipShape(Capsule())

            Button("Reply") {
                Task {
                    await viewModel.sendComment(postId: post.id)
                }
            }
            .font(AppFont.gillSwiftUI(.bold, size: 16))
            .foregroundColor(Color(hex: "1A1018"))
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

