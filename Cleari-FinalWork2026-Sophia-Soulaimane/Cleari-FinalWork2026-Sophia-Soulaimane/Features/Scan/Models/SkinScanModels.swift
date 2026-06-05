//
//  SkinScanModels.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation

struct SkinScanResponse: Codable {
    let success: Bool
    let message: String
    let analysis: ScanAnalysis?
    let scan: SkinScan   
}

struct ScanAnalysis: Codable {
    let id: Int?
    let userId: Int?
    let imageUrl: String?
    let result: String?
    let rawResultJson: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId        = "user_id"
        case imageUrl      = "image_url"
        case result
        case rawResultJson = "raw_result_json"
        case createdAt
    }
}

struct SkinScan: Codable {
    let scores: SkinScores
    let recommendation: SkinRecommendation
    let insights: [SkinInsight]?
}

struct SkinScores: Codable {
    let acne: SkinScore?
    let redness: SkinScore?
    let oiliness: SkinScore?
    let texture: SkinScore?
    let moisture: SkinScore?
}

struct SkinScore: Codable {
    let uiScore: Int?
}

struct SkinRecommendation: Codable {
    let skinTypeEstimate: String?
    let recommendationLevel: String?
    let shortAdvice: String?
}

struct SkinInsight: Codable, Identifiable {
    var id: String { key }

    let key: String
    let title: String
    let level: String
    let shortText: String
    let tip: String
}

// MARK: - Scan History

struct ScanHistoryResponse: Codable {
    let scans: [ScanHistoryRecord]
}

struct ScanHistoryRecord: Codable, Identifiable {
    let id: Int
    let imageUrl: String?
    let result: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl  = "image_url"
        case result
        case createdAt
    }

    /// Parses the JSON string stored in `result` into a SkinScan.
    var parsedScan: SkinScan? {
        guard let result, let data = result.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(SkinScan.self, from: data)
    }

    /// Transforms the stored Cloudinary URL to deliver JPEG (avoids HEIC issues on iOS).
    /// Original URL is never modified in the database.
    var displayImageUrl: URL? {
        guard let raw = imageUrl, raw.hasPrefix("http") else { return nil }
        let jpgUrl = raw.replacingOccurrences(of: "/upload/", with: "/upload/f_jpg,q_80/")
        return URL(string: jpgUrl)
    }

    var formattedDate: String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: createdAt) {
            let fmt = DateFormatter()
            fmt.dateStyle = .medium
            fmt.timeStyle = .short
            return fmt.string(from: date)
        }
        let iso2 = ISO8601DateFormatter()
        if let date = iso2.date(from: createdAt) {
            let fmt = DateFormatter()
            fmt.dateStyle = .medium
            return fmt.string(from: date)
        }
        return createdAt
    }
}
