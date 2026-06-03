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
    let patient: ConversationPatient?
}

struct ConversationPatient: Codable, Hashable {
    // Decoded via ChatService's convertFromSnakeCase decoder — no explicit CodingKeys.
    let id: Int
    let username: String?
    let firstName: String?
    let lastName: String?
    let profilePictureUrl: String?

    var displayName: String {
        let parts = [firstName, lastName].compactMap { $0 }.filter { !$0.isEmpty }
        if !parts.isEmpty { return parts.joined(separator: " ") }
        if let username, !username.isEmpty { return username }
        return "Patient #\(id)"
    }
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

struct AppointmentSuggestionResponse: Codable {
    let message: String
    let appointmentMessage: ChatMessage
}

// MARK: - Patient data (dermatologist view)
// All decoded via ChatService's convertFromSnakeCase decoder — plain camelCase, no snake_case CodingKeys.

struct PatientScanResponse: Codable {
    let scans: [PatientScanRecord]
}

struct PatientScanRecord: Codable, Identifiable {
    let id: Int
    let imageUrl: String?
    let result: String?
    let createdAt: String?

    var parsedSkinScan: SkinScanBrief? {
        guard let result, let data = result.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(SkinScanBrief.self, from: data)
    }

    var displayImageUrl: URL? {
        guard let raw = imageUrl, raw.hasPrefix("http") else { return nil }
        let jpg = raw.replacingOccurrences(of: "/upload/", with: "/upload/f_jpg,q_80/")
        return URL(string: jpg)
    }

    var formattedDate: String {
        guard let createdAt else { return "" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: createdAt) {
            let fmt = DateFormatter(); fmt.dateStyle = .medium; fmt.timeStyle = .short
            return fmt.string(from: date)
        }
        if let date = ISO8601DateFormatter().date(from: createdAt) {
            let fmt = DateFormatter(); fmt.dateStyle = .medium
            return fmt.string(from: date)
        }
        return createdAt
    }
}

/// Minimal decoded scan result (the `result` JSON string is camelCase, decoded with a plain decoder)
struct SkinScanBrief: Codable {
    let recommendation: SkinScanRecommendationBrief?
    let insights: [SkinScanInsightBrief]?
}

struct SkinScanRecommendationBrief: Codable {
    let skinTypeEstimate: String?
    let shortAdvice: String?
}

struct SkinScanInsightBrief: Codable, Identifiable {
    var id: String { key }
    let key: String
    let title: String
    let level: String
    let shortText: String
    let tip: String
}

struct PatientFormResponse: Codable {
    let form: PatientFormRecord?
}

struct PatientFormRecord: Codable {
    let id: Int?
    let skinFeeling: String?
    let productReaction: String?
    let flakiness: String?
    let diagnosedCondition: String?
    let hasAllergies: String?
    let allergiesDetails: String?
    let hasSkinIssues: String?
    let mainConcern: String?
    let stepCompleted: String?
    let createdAt: String?
}

struct PatientRoutineResponse: Codable {
    let routines: [PatientRoutineRecord]
}

struct PatientRoutineRecord: Codable, Identifiable {
    let id: Int
    let productName: String?
    let productImageUrl: String?
    let usageTime: String?
    let notes: String?

    var displayImageUrl: URL? {
        guard let raw = productImageUrl, raw.hasPrefix("http") else { return nil }
        let jpg = raw.replacingOccurrences(of: "/upload/", with: "/upload/f_jpg,q_80/")
        return URL(string: jpg)
    }
}
