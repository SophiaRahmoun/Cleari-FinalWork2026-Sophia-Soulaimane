//
//  FakeTrendComment.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 23/05/2026.
//

import Foundation

struct FakeTrendComment: Codable, Identifiable {
    let id: Int
    let content: String
    let userId: Int
    let fakeTrendPostId: Int
    let parentCommentId: Int?
    let createdAt: String
    let updatedAt: String
    let User: FakeTrendCommentUser
    let childComments: [FakeTrendComment]?
}

struct FakeTrendCommentUser: Codable {
    let id: Int
    let username: String
    let email: String
    let role: String
}

struct CreateFakeTrendCommentResponse: Codable {
    let id: Int
    let content: String
    let userId: Int
    let fakeTrendPostId: Int
    let parentCommentId: Int?
    let createdAt: String
    let updatedAt: String
}
