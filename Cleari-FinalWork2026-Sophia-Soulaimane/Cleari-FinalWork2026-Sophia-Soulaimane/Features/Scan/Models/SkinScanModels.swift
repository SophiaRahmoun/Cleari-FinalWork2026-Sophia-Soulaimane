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
    let scan: SkinScan   
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
