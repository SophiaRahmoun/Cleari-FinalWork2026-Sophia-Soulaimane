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
}
