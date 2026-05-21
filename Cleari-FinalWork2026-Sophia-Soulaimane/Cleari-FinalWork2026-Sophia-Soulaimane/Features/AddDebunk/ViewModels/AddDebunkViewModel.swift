//
//  AddDebunkViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import Foundation

@MainActor
final class AddDebunkViewModel: ObservableObject {
    @Published var isPosting = false
    @Published var errorMessage: String?

    func createDebunkPost(
        title: String,
        trendName: String,
        description: String,
        debunkExplanation: String,
        tiktokUrl: String?,
        status: String?
    ) async -> Bool {
        isPosting = true
        errorMessage = nil
        defer { isPosting = false }

        do {
            try await AddDebunkService.shared.createDebunkPost(
                title: title,
                trendName: trendName,
                description: description,
                debunkExplanation: debunkExplanation,
                tiktokUrl: tiktokUrl,
                status: status
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("ERROR CREATING DEBUNK:", error.localizedDescription)
            return false
        }
    }
}
