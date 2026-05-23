//
//  FakeTrendPost.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 22/05/2026.
//

import Foundation

struct FakeTrendFeedResponse: Codable {
    let posts: [FakeTrendPost]
}

struct FakeTrendPost: Codable, Identifiable {
    let id: Int
    let title: String
    let trendName: String
    let skinTypeTag: String?
    let skinConcernTag: String?
    let description: String
    let debunkExplanation: String
    let tiktokUrl: String?
    let tiktokVideoId: String?
    let videoUrl: String?
    let imageUrl: String?
    let status: String
    let dermatologistId: Int
    let createdAt: String
    let updatedAt: String
    let dermatologist: FakeTrendDermatologist?

    var likesCount: Int?
    var isLikedByCurrentUser: Bool?
    var commentsCount: Int?
    var savesCount: Int?
}

struct FakeTrendDermatologist: Codable {
    let id: Int
    let username: String
    let email: String
}

struct FakeTrendLikeResponse: Codable {
    let message: String
    let likesCount: Int
    let isLikedByCurrentUser: Bool
}
