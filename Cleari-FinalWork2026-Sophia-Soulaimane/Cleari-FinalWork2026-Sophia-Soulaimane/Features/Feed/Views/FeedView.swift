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
    @State private var showDebunkFeed = false
    @State private var showLockedSheet = false
    @State private var showPayementView = false
    @State private var showProfile = false

    var body: some View {

        ZStack(alignment: .bottom) {

            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                LazyVStack(alignment: .leading, spacing: 16) {

                    FeedTopBar(
                        onFakeTrendsTapped: {
                            if TokenStorage.shared.hasFakeTrendAccess {
                                showDebunkFeed = true
                            } else {
                                showLockedSheet = true
                            }
                        },
                        onProfileTapped: {
                            showProfile = true
                        }
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
            if showLockedSheet {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showLockedSheet = false
                    }

                FakeTrendLockedSheet {
                    showLockedSheet = false
                    showPayementView = true
                } onNotNowTapped: {
                    showLockedSheet = false
                }
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {

            await viewModel.fetchPosts()

            do {

                try await PayementService.shared.fetchSubscriptionStatus()

            } catch {

                print("Failed to fetch subscription status:", error)
            }
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
        .fullScreenCover(isPresented: $showDebunkFeed) {
            DebunkFeedView(
                isDermatologist: TokenStorage.shared.userRole == "dermatologist"
            )
        }
        .fullScreenCover(isPresented: $showPayementView) {
            PayementView()
        }
        .fullScreenCover(isPresented: $showProfile) {
            UserProfileView()
        }
    }
}
