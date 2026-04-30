//
//  AuthModels.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation

struct AuthResponse: Codable {
    let message: String
    let token: String
    let user: AuthUser
}

struct AuthUser: Codable {
    let id: Int
    let username: String
    let email: String
    let role: String
}

struct LoginRequest: Codable {

    let email: String
    let password: String

}

struct RegisterUserRequest: Codable {

    let username: String
    let email: String
    let password: String

}

struct RegisterDermatologistRequest: Codable {

    let username: String

    let email: String

    let password: String

    let specialization: String?

    let license_number: String?

    let bio: String?

}
