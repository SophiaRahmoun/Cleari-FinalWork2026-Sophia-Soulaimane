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
}
