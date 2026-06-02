//
//  Dermatologist.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import Foundation

// Wraps the { "dermatologists": [...] } envelope returned by the backend
struct DermatologistsResponse: Decodable {
    let dermatologists: [Dermatologist]
}

// Matches GET /api/dermatologists/verified
// Each item is a DermatologistProfile row with a nested "user" object
struct Dermatologist: Codable, Identifiable {
    let id: Int               // DermatologistProfile.id
    let userId: Int           // user_id — used to create a conversation
    let firstName: String?
    let city: String?
    let bio: String?
    let specialization: String?
    let user: DermatologistUser?

    // Convenience helpers used in the UI
    var displayName: String {
        user?.username ?? firstName ?? "Dermatologist"
    }
    var profileImageUrl: String? {
        user?.profilePictureUrl
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId       = "user_id"
        case firstName    = "first_name"
        case city
        case bio
        case specialization
        case user
    }
}

struct DermatologistUser: Codable {
    let id: Int
    let username: String
    let email: String
    let profilePictureUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case profilePictureUrl = "profile_picture_url"
    }
}
