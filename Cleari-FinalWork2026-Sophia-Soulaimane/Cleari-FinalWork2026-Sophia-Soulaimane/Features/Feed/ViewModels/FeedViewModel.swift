//
//  FeedViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import Foundation

@MainActor
final class FeedViewModel: ObservableObject {

    @Published var posts: [CommunityPost] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchPosts() async {
        isLoading = true
        errorMessage = nil

        do {
            posts = try await CommunityPostService.shared.fetchPosts()
        } catch {
            errorMessage = error.localizedDescription
            print("ERROR FETCHING POSTS:", error.localizedDescription)
        }

        isLoading = false
    }

    func toggleLike(for post: CommunityPost) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        do {
            let isLiked = posts[index].isLikedByCurrentUser ?? false
            let response: LikeResponse

            if isLiked {
                response = try await CommunityPostService.shared.unlikePost(postId: post.id)
            } else {
                response = try await CommunityPostService.shared.likePost(postId: post.id)
            }

            posts[index].likesCount = response.likesCount
            posts[index].isLikedByCurrentUser = response.isLikedByCurrentUser

        } catch {
            print("ERROR TOGGLING LIKE:", error.localizedDescription)
        }
    }
}
