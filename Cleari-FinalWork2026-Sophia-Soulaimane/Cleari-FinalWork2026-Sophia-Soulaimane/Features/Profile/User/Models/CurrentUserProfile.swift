//
//  CurrentUserProfile.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/05/2026.
//

import Foundation

struct CurrentUserProfile: Codable {
    let id: Int
    let username: String
    let email: String
    let role: String
    let profilePictureUrl: String?
    let language: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case role
        case profilePictureUrl = "profile_picture_url"
        case language
        case createdAt
    }
}
