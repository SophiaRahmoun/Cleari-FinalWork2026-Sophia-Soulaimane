//
//  ChatService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 29/05/2026.
//

import Foundation
import UIKit

final class ChatService {
    static let shared = ChatService()

    private let baseURL = "\(APIConfig.baseURL)/chat"

    // All chat API responses use snake_case from the backend
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    private init() {}

    func fetchMessages(conversationId: Int) async throws -> ConversationMessagesResponse {
        guard let url = URL(string: "\(baseURL)/conversations/\(conversationId)/messages") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(ConversationMessagesResponse.self, from: data)
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
        let response = try decoder.decode(SendMessageResponse.self, from: data)
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
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(CreateConversationResponse.self, from: data).conversation
    }

    func sendImageMessage(conversationId: Int, imageData: Data) async throws -> ChatMessage {
        guard let url = URL(string: "\(baseURL)/conversations/\(conversationId)/messages/image") else {
            throw URLError(.badURL)
        }
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"chat.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(SendMessageResponse.self, from: data).newMessage
    }

    func requestAppointment(conversationId: Int) async throws -> ChatMessage {
        guard let url = URL(string: "\(baseURL)/conversations/\(conversationId)/request-appointment") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(AppointmentSuggestionResponse.self, from: data).appointmentMessage
    }
}
