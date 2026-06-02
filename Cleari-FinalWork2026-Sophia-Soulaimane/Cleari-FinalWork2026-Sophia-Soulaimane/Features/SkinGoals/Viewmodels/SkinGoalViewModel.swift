//
//  SkinGoalViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

@MainActor
final class SkinGoalViewModel: ObservableObject {
    @Published var aboutUser: String = ""
    @Published var selectedSkinGoals: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    func fetchSkinGoals() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await SkinGoalService.shared.fetchSkinGoals()
            aboutUser = response.description
            selectedSkinGoals = Set(response.selectedGoals)
        } catch {
            errorMessage = "Could not load skin goals."
            print("FETCH SKIN GOALS ERROR:", error.localizedDescription)
        }
    }

    func saveSkinGoals() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        defer {
            isLoading = false
        }

        do {
            try await SkinGoalService.shared.saveSkinGoals(
                description: aboutUser,
                selectedGoals: Array(selectedSkinGoals)
            )

            successMessage = "Skin goals saved successfully."
            print("SKIN GOALS SAVED")
        } catch {
            errorMessage = "Could not save skin goals."
            print("SAVE SKIN GOALS ERROR:", error.localizedDescription)
        }
    }

    func toggleGoal(_ goal: String) {
        if selectedSkinGoals.contains(goal) {
            selectedSkinGoals.remove(goal)
        } else {
            selectedSkinGoals.insert(goal)
        }
    }
}
