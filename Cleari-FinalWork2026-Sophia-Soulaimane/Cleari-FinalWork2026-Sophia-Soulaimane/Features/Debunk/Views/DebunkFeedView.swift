//
//  DebunkFeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct DebunkFeedView: View {
    @StateObject private var viewModel = DebunkFeedViewModel()
    @State private var showAddDebunk = false

    var isDermatologist: Bool = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 26) {
                        FeedTopBar(
                            onExploreTapped: {
                                dismiss()
                            }
                        )

                        filters

                        if isDermatologist {
                            AddDebunkButton {
                                showAddDebunk = true
                            }
                            .padding(.horizontal, 80)
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else {
                            ForEach(viewModel.posts) { post in
                                DebunkPostCard(
                                    post: post,
                                    onLikeTapped: {
                                        Task {
                                            await viewModel.toggleLike(for: post)
                                        }
                                    }
                                )                                    .padding(.horizontal, 34)
                            }
                        }
                    }
                    .padding(.top, 55)
                    .padding(.bottom, 30)
                }

                DebunkReplyBar(imageName: "ProfileSample")
                    .padding(.horizontal, 34)
                    .padding(.bottom, 14)

                ScanBottomBar()
            }
        }
        .task {
            await viewModel.fetchPosts()
        }
        .fullScreenCover(isPresented: $showAddDebunk, onDismiss: {
            Task {
                await viewModel.fetchPosts()
            }
        }) {
            AddDebunkView()
        }
    }

    private var filters: some View {
        HStack(spacing: 12) {
            DermatologistFilterLabel(title: "All", isSelected: true)
            DermatologistFilterLabel(title: "Acne")
            DermatologistFilterLabel(title: "Aging")
            DermatologistFilterLabel(title: "Sensitive")
        }
        .padding(.horizontal, 34)
    }
}
