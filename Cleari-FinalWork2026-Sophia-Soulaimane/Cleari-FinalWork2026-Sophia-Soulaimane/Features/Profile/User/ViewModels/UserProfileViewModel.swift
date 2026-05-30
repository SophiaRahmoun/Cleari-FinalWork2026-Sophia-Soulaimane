//
//  UserProfileViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/05/2026.
//

import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published var user: CurrentUserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchCurrentUser() async {
        isLoading = true
        errorMessage = nil

        do {
            user = try await UserProfileService.shared.fetchCurrentUser()
        } catch {
            errorMessage = "Could not load profile."
            print("PROFILE ERROR:", error.localizedDescription)
        }

        isLoading = false
    }

    var fullName: String {
        user?.username ?? "Loading..."
    }

    var username: String {
        user?.username ?? "loading"
    }

    var memberSince: String {
        guard let createdAt = user?.createdAt else {
            return "2026"
        }

        return String(createdAt.prefix(4))
    }
}
