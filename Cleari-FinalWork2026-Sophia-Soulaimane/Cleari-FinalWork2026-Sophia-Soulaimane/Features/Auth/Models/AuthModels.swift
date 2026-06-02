//
//  AuthModels.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation
struct AuthResponse: Codable {
    let message: String?
    let token: String
    let user: AuthUser
}

struct AuthUser: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let role: String
    let dermatologistProfile: AuthDermatologistProfile?
        enum CodingKeys: String, CodingKey {
            case id
            case username
            case email
            case role
            case dermatologistProfile
        }
}
struct AuthDermatologistProfile: Codable {
    let id: Int?
    let verified: Bool?
    let verificationStatus: String?
    enum CodingKeys: String, CodingKey {
        case id
        case verified
        case verificationStatus = "verification_status"
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterUserRequest: Codable {
    let first_name: String
    let last_name: String
    let username: String
    let email: String
    let password: String
}

struct RegisterDermatologistRequest: Codable {
    let first_name: String
    let last_name: String
    let username: String
    let email: String
    let password: String
    let specialization: String?
    let convention_status: String?
    let inami_number: String?
}
