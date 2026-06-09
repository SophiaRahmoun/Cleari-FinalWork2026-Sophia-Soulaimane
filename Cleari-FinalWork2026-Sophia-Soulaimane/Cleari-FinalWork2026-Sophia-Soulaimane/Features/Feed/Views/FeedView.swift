//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedView: View {
    var onFakeTrendsTapped: (() -> Void)? = nil
    var onProfileTapped: (() -> Void)? = nil
    var onPostSelected: ((CommunityPost) -> Void)? = nil

    @StateObject private var viewModel = FeedViewModel()
    @State private var showCreatePost = false

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {

                    FeedTopBar(
                        onExploreTapped: nil,
                        onFakeTrendsTapped: onFakeTrendsTapped,
                        onProfileTapped: onProfileTapped
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
                                    onPostSelected?(post)
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
    }

    func refresh() async {
        await viewModel.fetchPosts()
    }
}

#Preview {
    FeedView()
}
