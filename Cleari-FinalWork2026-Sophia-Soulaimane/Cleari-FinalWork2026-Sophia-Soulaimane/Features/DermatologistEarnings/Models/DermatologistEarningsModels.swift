//
//  DermatologistEarningsModels.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 03/06/2026.
//

import Foundation

struct DermatologistEarningsResponse: Decodable {
    let totalPosts: Int
    let totalLikes: Int
    let totalComments: Int
    let estimatedEarnings: Double
    let posts: [EarningsPost]
}

struct EarningsPost: Decodable, Identifiable {
    let id: Int
    let title: String
    let trendName: String
    let imageUrl: String?
    let createdAt: String
    let likesCount: Int
    let commentsCount: Int
    let estimatedReward: Double
}
