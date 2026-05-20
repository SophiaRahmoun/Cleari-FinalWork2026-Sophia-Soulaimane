//
//  CommunityPostComment.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 20/05/2026.
//

import Foundation

struct CommunityPostComment: Codable, Identifiable {
    let id: Int
    let content: String
    let userId: Int
    let postId: Int
    let createdAt: String
    let updatedAt: String
    let User: PostUser
}
