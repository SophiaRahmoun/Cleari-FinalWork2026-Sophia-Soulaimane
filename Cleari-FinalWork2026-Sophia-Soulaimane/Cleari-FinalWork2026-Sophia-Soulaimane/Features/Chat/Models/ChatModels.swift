//
//  ChatModels.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 29/05/2026.
//

import Foundation

struct Conversation: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let dermatologistId: Int
    let scanId: Int?
    let formId: Int?
    let status: String
    let lastMessageAt: String?
}

struct ChatMessage: Codable, Identifiable, Hashable {
    let id: Int
    let conversationId: Int
    let senderId: Int
    let senderRole: String
    let content: String
    let messageType: String
    let isRead: Bool
    let createdAt: String?
}

struct ConversationMessagesResponse: Codable {
    let conversation: Conversation
    let messages: [ChatMessage]
}

struct SendMessageRequest: Codable {
    let content: String
    let messageType: String
}

struct SendMessageResponse: Codable {
    let message: String
    let newMessage: ChatMessage
}
struct CreateConversationRequest: Codable {
    let dermatologistId: Int
    let scanId: Int?
    let formId: Int?
    let firstMessage: String?
}

struct CreateConversationResponse: Codable {
    let message: String
    let conversation: Conversation
}
