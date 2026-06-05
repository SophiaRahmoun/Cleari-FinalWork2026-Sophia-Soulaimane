//
//  DermatologistEarningsViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 03/06/2026.
//

import Foundation

final class DermatologistEarningsViewModel: ObservableObject {
    @Published var totalPosts: Int = 0
    @Published var totalLikes: Int = 0
    @Published var totalComments: Int = 0
    @Published var estimatedEarnings: Double = 0
    @Published var posts: [EarningsPost] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = DermatologistEarningsService.shared

    func fetchEarnings() async {
        await MainActor.run { isLoading = true }

        do {
            let response = try await service.fetchEarnings()

            await MainActor.run {
                self.totalPosts = response.totalPosts
                self.totalLikes = response.totalLikes
                self.totalComments = response.totalComments
                self.estimatedEarnings = response.estimatedEarnings
                self.posts = response.posts
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
