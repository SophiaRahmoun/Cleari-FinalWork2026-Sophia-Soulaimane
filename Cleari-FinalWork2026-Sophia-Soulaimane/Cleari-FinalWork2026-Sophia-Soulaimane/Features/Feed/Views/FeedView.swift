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
    @State private var showFakeTrends = false
    @State private var showProfile = false
    @State private var selectedPost: CommunityPost? = nil

    private var isDermatologist: Bool {
        TokenStorage.shared.userRole == "dermatologist"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()
                .allowsHitTesting(false)

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {

                    FeedTopBar(
                        onExploreTapped: nil,
                        onFakeTrendsTapped: { showFakeTrends = true },
                        onProfileTapped: { showProfile = true }
                    )
                    .zIndex(10)

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
        .fullScreenCover(isPresented: $showFakeTrends) {
            DebunkFeedView(isDermatologist: isDermatologist)
        }
        .fullScreenCover(isPresented: $showProfile) {
            UserProfileView()
        }
        .fullScreenCover(item: $selectedPost) { post in
            PostDetailView(post: post)
        }
    }

    func refresh() async {
        await viewModel.fetchPosts()
    }
}

#Preview {
    FeedView()
}
