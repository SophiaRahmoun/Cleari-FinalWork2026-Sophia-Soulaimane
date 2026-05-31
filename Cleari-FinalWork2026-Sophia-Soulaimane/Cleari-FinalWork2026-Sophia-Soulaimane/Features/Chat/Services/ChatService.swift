//
//  ChatService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 29/05/2026.
//


import Foundation

final class ChatService {
    static let shared = ChatService()

    private let baseURL = "\(APIConfig.baseURL)/chat"

    private init() {}

    func fetchMessages(conversationId: Int) async throws -> ConversationMessagesResponse {
        guard let url = URL(string: "\(baseURL)/conversations/\(conversationId)/messages") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ConversationMessagesResponse.self, from: data)
    }

    func sendMessage(conversationId: Int, content: String, messageType: String = "text") async throws -> ChatMessage {
        guard let url = URL(string: "\(baseURL)/conversations/\(conversationId)/messages") else {
            throw URLError(.badURL)
        }

        let body = SendMessageRequest(content: content, messageType: messageType)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SendMessageResponse.self, from: data)

        return response.newMessage
    }
}
