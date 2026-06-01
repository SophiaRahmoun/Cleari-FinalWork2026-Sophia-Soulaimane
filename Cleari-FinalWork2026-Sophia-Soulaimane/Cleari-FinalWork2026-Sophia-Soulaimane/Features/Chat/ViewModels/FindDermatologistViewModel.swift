//
//  FindDermatologistViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import Foundation

@MainActor
final class FindDermatologistViewModel: ObservableObject {
    @Published var dermatologists: [Dermatologist] = []
    @Published var selectedConversation: Conversation?
    @Published var selectedDermatologist: Dermatologist?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadDermatologists() async {
        isLoading = true
        errorMessage = nil

        do {
            dermatologists = try await DermatologistService.shared.fetchDermatologists()
        } catch {
            errorMessage = "Could not load dermatologists."
            print("LOAD DERMATOLOGISTS ERROR:", error.localizedDescription)
        }

        isLoading = false
    }

    func startChat(with dermatologist: Dermatologist) async {
        isLoading = true
        errorMessage = nil
        selectedDermatologist = dermatologist

        do {
            // dermatologist.userId = the User.id of the dermato (not the profile id)
            let conversation = try await ChatService.shared.createConversation(
                dermatologistId: dermatologist.userId,
                scanId: nil,
                formId: nil,
                firstMessage: nil
            )
            selectedConversation = conversation
        } catch {
            errorMessage = "Could not start chat."
            print("START CHAT ERROR:", error.localizedDescription)
        }

        isLoading = false
    }
}
