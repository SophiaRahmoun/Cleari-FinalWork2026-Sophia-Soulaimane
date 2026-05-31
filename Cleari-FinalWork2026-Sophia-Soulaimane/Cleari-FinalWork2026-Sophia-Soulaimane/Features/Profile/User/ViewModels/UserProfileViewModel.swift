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
        let firstName = user?.firstName ?? ""
        let lastName = user?.lastName ?? ""

        let realName = "\(firstName) \(lastName)"
            .trimmingCharacters(in: .whitespaces)

        return realName.isEmpty
            ? (user?.username ?? "loading")
            : realName
    }

    var memberSince: String {
        guard let createdAt = user?.createdAt else {
            return "Unknown"
        }

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = inputFormatter.date(from: createdAt) else {
            return createdAt
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"

        return outputFormatter.string(from: date)
    }
}
