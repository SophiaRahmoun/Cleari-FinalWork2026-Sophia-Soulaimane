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
    func createConversation(
        dermatologistId: Int,
        scanId: Int? = nil,
        formId: Int? = nil,
        firstMessage: String? = nil
    ) async throws -> Conversation {
        guard let url = URL(string: "\(baseURL)/conversations") else {
            throw URLError(.badURL)
        }

        let body = CreateConversationRequest(
            dermatologistId: dermatologistId,
            scanId: scanId,
            formId: formId,
            firstMessage: firstMessage
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(CreateConversationResponse.self, from: data)
        return decodedResponse.conversation
    }
    func requestAppointment(conversationId: Int) async throws -> ChatMessage {
        guard let url = URL(string: "\(baseURL)/conversations/\(conversationId)/request-appointment") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(AppointmentSuggestionResponse.self, from: data)
        return decodedResponse.appointmentMessage
    }
}
