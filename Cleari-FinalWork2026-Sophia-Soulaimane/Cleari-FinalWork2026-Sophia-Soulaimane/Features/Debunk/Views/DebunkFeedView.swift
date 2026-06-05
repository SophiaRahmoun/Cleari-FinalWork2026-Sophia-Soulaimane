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
    @State private var selectedPost: FakeTrendPost?
    @State private var showProfile = false
    @State private var showFindDermatologist = false
    @State private var showScan = false
    @State private var showCalendar = false

    var isDermatologist: Bool = false

    @Environment(\.dismiss) private var dismiss
    var body: some View {

        ZStack {

            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(spacing: 26) {

                    FeedTopBar(
                        onExploreTapped: { dismiss() },
                        onProfileTapped: { showProfile = true },
                        activeTab: .fakeTrends
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
                                },
                                onCommentTapped: {
                                    selectedPost = post
                                }
                            )
                            .padding(.horizontal, 34)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ScanBottomBar(
                    onHomeTapped: { dismiss() },
                    onFindDermatologistTapped: { showFindDermatologist = true },
                    onScanTapped: { showScan = true },
                    onCalendarTapped: { showCalendar = true }
                )
                .padding(.bottom, 8)
            }
        }
        .task {

            await viewModel.fetchPosts()
        }

        .fullScreenCover(isPresented: $showProfile) {
            UserProfileView()
        }
        .fullScreenCover(isPresented: $showFindDermatologist) {
            FindDermatologistView()
        }
        .fullScreenCover(isPresented: $showScan) {
            CameraCaptureView()
        }
        .fullScreenCover(isPresented: $showCalendar) {
            MyAppointmentsView()
        }
        .fullScreenCover(isPresented: $showAddDebunk, onDismiss: {

            Task {
                await viewModel.fetchPosts()
            }

        }) {

            AddDebunkView()
        }

        .fullScreenCover(item: $selectedPost, onDismiss: {

            Task {
                await viewModel.fetchPosts()
            }

        }) { post in

            DebunkDetailView(post: post)
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
