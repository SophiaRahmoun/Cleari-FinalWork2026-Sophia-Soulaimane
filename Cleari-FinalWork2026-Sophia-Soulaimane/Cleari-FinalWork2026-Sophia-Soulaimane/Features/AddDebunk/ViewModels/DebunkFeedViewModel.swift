//
//  DebunkFeedViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 22/05/2026.
//

import Foundation

@MainActor
final class DebunkFeedViewModel: ObservableObject {
    @Published var posts: [FakeTrendPost] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchPosts() async {
        isLoading = true
        errorMessage = nil

        do {
            posts = try await DebunkService.shared.fetchFakeTrendPosts()
        } catch {
            errorMessage = error.localizedDescription
            print("ERROR FETCHING FAKE TRENDS:", error.localizedDescription)
        }

        isLoading = false
    }
    func toggleLike(for post: FakeTrendPost) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        do {
            let isLiked = posts[index].isLikedByCurrentUser ?? false
            let response: FakeTrendLikeResponse

            if isLiked {
                response = try await DebunkService.shared.unlikeFakeTrendPost(postId: post.id)
            } else {
                response = try await DebunkService.shared.likeFakeTrendPost(postId: post.id)
            }

            posts[index].likesCount = response.likesCount
            posts[index].isLikedByCurrentUser = response.isLikedByCurrentUser

        } catch {
            print("ERROR TOGGLING FAKE TREND LIKE:", error.localizedDescription)
        }
    }
}
