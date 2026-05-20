//
//  CommunityPost.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 17/05/2026.
//

import Foundation

struct CommunityPost: Codable, Identifiable {
    let id: Int
    let content: String
    let imageUrl: String?
    let userId: Int
    let createdAt: String
    let updatedAt: String
    let User: PostUser

    var likesCount: Int?
    var isLikedByCurrentUser: Bool?
    var commentsCount: Int?

}

struct PostUser: Codable {
    let id: Int
    let username: String
    let email: String
}

struct LikeResponse: Codable {
    let message: String
    let likesCount: Int
    let isLikedByCurrentUser: Bool
}
