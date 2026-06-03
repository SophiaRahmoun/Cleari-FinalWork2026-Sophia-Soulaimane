//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    @State private var showCreatePost  = false
    @State private var selectedPost: CommunityPost? = nil
    @State private var showDebunkFeed  = false
    @State private var showProfile     = false

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {

                    FeedTopBar(
                        onExploreTapped: nil,
                        onFakeTrendsTapped: { showDebunkFeed = true },
                        onProfileTapped:    { showProfile = true }
                    )

                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 50)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(viewModel.posts) { post in
                            FeedPostCard(
                                post: post,
                                onLikeTapped: {
                                    Task { await viewModel.toggleLike(for: post) }
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

            ReplyBar(onTap: { showCreatePost = true })
                .padding(.bottom, 16)
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
            Task { await viewModel.fetchPosts() }
        }) { post in
            PostDetailView(post: post)
        }
        .fullScreenCover(isPresented: $showDebunkFeed) {
            DebunkFeedView(isDermatologist: TokenStorage.shared.userRole == "dermatologist")
        }
        .fullScreenCover(isPresented: $showProfile, onDismiss: {
            Task { await viewModel.fetchPosts() }
        }) {
            UserProfileView()
        }
    }
}

#Preview {
    FeedView()
}
