//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedView: View {

    @StateObject private var viewModel = FeedViewModel()
    @State private var showCreatePost = false
    @State private var selectedPost: CommunityPost?

    var body: some View {

        ZStack(alignment: .bottom) {

            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                LazyVStack(alignment: .leading, spacing: 16) {

                    FeedTopBar()

                    if viewModel.isLoading {

                        ProgressView()
                            .padding(.top, 50)
                            .frame(maxWidth: .infinity)

                    } else {

                        ForEach(viewModel.posts) { post in

                            FeedPostCard(
                                post: post,
                                onLikeTapped: {
                                    Task {
                                        await viewModel.toggleLike(for: post)
                                    }
                                },
                                onCommentTapped: {
                                    selectedPost = post
                                }
                            )
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 220)
            }

            VStack(spacing: 0) {

                Rectangle()
                    .fill(Color(hex: "1A1018").opacity(0.35))
                    .frame(height: 1)

                ReplyBar {
                    showCreatePost = true
                }
                .padding(.top, 12)

                Spacer()
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity)
            .background(
                LinearGradientBackground(
                    startHex: "C66F8C",
                    endHex: "F9BDB9"
                )
                .ignoresSafeArea(edges: .bottom)
            )
        }
        .task {
            await viewModel.fetchPosts()
        }
        .sheet(isPresented: $showCreatePost) {
            CreatePostView {
                await viewModel.fetchPosts()
            }
        }
        .fullScreenCover(item: $selectedPost, onDismiss: {
            Task {
                await viewModel.fetchPosts()
            }
        }) { post in
            PostDetailView(post: post)
        }
    }
}
