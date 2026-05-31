//
//  UserProfileService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/05/2026.
//

import Foundation

final class UserProfileService {
    static let shared = UserProfileService()
    private init() {}

    func fetchCurrentUser() async throws -> CurrentUserProfile {
        guard let url = URL(string: "\(APIConfig.baseURL)/users/me") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(CurrentUserProfile.self, from: data)
    }
    func updateUsername(username: String) async throws -> String {
        guard let url = URL(string: "\(APIConfig.baseURL)/users/me/username") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = [
            "username": username
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            let backendError = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: backendError]
            )
        }

        return "Username updated successfully"
    }
    func updatePassword(
        currentPassword: String,
        newPassword: String,
        confirmPassword: String
    ) async throws -> String {
        guard let url = URL(string: "\(APIConfig.baseURL)/users/me/password") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = [
            "currentPassword": currentPassword,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            let backendError = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: backendError]
            )
        }

        return "Password updated successfully"
    }
}
