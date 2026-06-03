//
//  DermatologistEarningsView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 03/06/2026.
//

import SwiftUI

struct DermatologistEarningsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DermatologistEarningsViewModel()

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "1A1018")))
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: errorIcon(for: error))
                            .font(.system(size: 42))
                            .foregroundColor(Color(hex: "1A1018").opacity(0.45))

                        Text(errorTitle(for: error))
                            .font(AppFont.gillSwiftUI(.bold, size: 20))
                            .foregroundColor(Color(hex: "1A1018"))

                        Text(errorSubtitle(for: error))
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(Color(hex: "1A1018").opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 36)

                        Button {
                            Task { await viewModel.fetchEarnings() }
                        } label: {
                            Text("Try again")
                                .font(AppFont.gillSwiftUI(.bold, size: 15))
                                .foregroundColor(.white)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 12)
                                .background(Color(hex: "1A1018"))
                                .clipShape(Capsule())
                        }
                        .padding(.top, 4)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 22) {
                            summaryCard
                            postsSection
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchEarnings()
        }
    }

    // MARK: Header
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

            Text("My Earnings")
                .font(AppFont.gillSwiftUI(.bold, size: 28))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()

            Color.clear.frame(width: 28, height: 28)
        }
        .padding(.horizontal, 24)
        .padding(.top, 55)
        .padding(.bottom, 20)
    }

    // MARK: Summary Card
    private var summaryCard: some View {
        VStack(spacing: 18) {
            Text("Estimated Earnings")
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(Color(hex: "1A1018").opacity(0.7))

            Text(String(format: "€%.2f", viewModel.estimatedEarnings))
                .font(AppFont.gillSwiftUI(.bold, size: 42))
                .foregroundColor(Color(hex: "1A1018"))

            Text("Simulation — not a real payout")
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(Color(hex: "1A1018").opacity(0.5))
                .italic()

            Divider()
                .background(Color(hex: "1A1018").opacity(0.2))

            HStack(spacing: 0) {
                statItem(label: "Posts", value: "\(viewModel.totalPosts)")
                Divider()
                    .frame(height: 36)
                    .background(Color(hex: "1A1018").opacity(0.2))
                statItem(label: "Likes", value: "\(viewModel.totalLikes)")
                Divider()
                    .frame(height: 36)
                    .background(Color(hex: "1A1018").opacity(0.2))
                statItem(label: "Comments", value: "\(viewModel.totalComments)")
            }
        }
        .padding(24)
        .background(Color.white.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppFont.gillSwiftUI(.bold, size: 22))
                .foregroundColor(Color(hex: "1A1018"))
            Text(label)
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(Color(hex: "1A1018").opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Posts Section
    private var postsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Debunk Posts")
                .font(AppFont.gillSwiftUI(.bold, size: 20))
                .foregroundColor(Color(hex: "1A1018"))

            if viewModel.posts.isEmpty {
                Text("No debunk posts yet. Start publishing to earn rewards!")
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(Color(hex: "1A1018").opacity(0.6))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
            } else {
                ForEach(viewModel.posts) { post in
                    earningsPostCard(post)
                }
            }
        }
    }

    // MARK: Error helpers
    private func errorIcon(for error: String) -> String {
        if error.contains("404") { return "cloud.slash" }
        if error.contains("403") { return "lock.shield" }
        if error.contains("401") { return "person.crop.circle.badge.xmark" }
        if error.contains("500") { return "server.rack" }
        return "wifi.exclamationmark"
    }

    private func errorTitle(for error: String) -> String {
        if error.contains("404") { return "Feature not deployed yet" }
        if error.contains("403") { return "Access denied" }
        if error.contains("401") { return "Session expired" }
        if error.contains("500") { return "Server error" }
        return "Connection failed"
    }

    private func errorSubtitle(for error: String) -> String {
        if error.contains("404") { return "The earnings endpoint is missing on the server.\nPush & redeploy your backend on Render." }
        if error.contains("403") { return "Your account doesn't have dermatologist access.\nCheck the role stored in your token." }
        if error.contains("401") { return "Your session has expired.\nLog out and log back in." }
        if error.contains("500") { return "Something went wrong on the server.\nCheck your Render logs for details." }
        return "Could not reach the server.\nMake sure your backend is running and the API URL is correct."
    }

    private func earningsPostCard(_ post: EarningsPost) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color(hex: "1A1018").opacity(0.1)
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "1A1018").opacity(0.08))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "doc.text")
                                .foregroundColor(Color(hex: "1A1018").opacity(0.4))
                        )
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(AppFont.gillSwiftUI(.bold, size: 16))
                        .foregroundColor(Color(hex: "1A1018"))
                        .lineLimit(2)

                    Text(post.trendName)
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(Color(hex: "1A1018").opacity(0.6))
                }

                Spacer()

                Text(String(format: "€%.2f", post.estimatedReward))
                    .font(AppFont.gillSwiftUI(.bold, size: 17))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            HStack(spacing: 18) {
                Label("\(post.likesCount) likes", systemImage: "heart.fill")
                    .font(AppFont.gillSwiftUI(.regular, size: 13))
                    .foregroundColor(Color(hex: "C66F8C"))

                Label("\(post.commentsCount) comments", systemImage: "bubble.left.fill")
                    .font(AppFont.gillSwiftUI(.regular, size: 13))
                    .foregroundColor(Color(hex: "1A1018").opacity(0.6))
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
