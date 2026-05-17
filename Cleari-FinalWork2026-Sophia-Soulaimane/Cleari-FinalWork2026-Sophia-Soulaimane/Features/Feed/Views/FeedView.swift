//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedView: View {

    @StateObject private var viewModel = FeedViewModel()

    var body: some View {

        ZStack {

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

                            UserQuestionRow(post: post)

                            FeedPostCard(post: post)

                            PostActionsRow()

                            ReplyBar()
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .task {
            await viewModel.fetchPosts()
        }
    }
}
