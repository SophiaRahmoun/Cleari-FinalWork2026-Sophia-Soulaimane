//
//  ChatViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var conversation: Conversation?
    @Published var messages: [ChatMessage] = []
    @Published var newMessage: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    let conversationId: Int
    let currentUserId: Int

    init(conversationId: Int, currentUserId: Int) {
        self.conversationId = conversationId
        self.currentUserId = currentUserId
    }

    func loadMessages() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await ChatService.shared.fetchMessages(conversationId: conversationId)
            self.conversation = response.conversation
            self.messages = response.messages
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func sendMessage() async {
        let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return }

        do {
            let sentMessage = try await ChatService.shared.sendMessage(
                conversationId: conversationId,
                content: trimmed
            )

            messages.append(sentMessage)
            newMessage = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func sendImageMessage(image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        do {
            let sentMessage = try await ChatService.shared.sendImageMessage(
                conversationId: conversationId,
                imageData: imageData
            )
            messages.append(sentMessage)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func requestAppointment() async {
        do {
            let message = try await ChatService.shared.requestAppointment(
                conversationId: conversationId
            )

            messages.append(message)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
