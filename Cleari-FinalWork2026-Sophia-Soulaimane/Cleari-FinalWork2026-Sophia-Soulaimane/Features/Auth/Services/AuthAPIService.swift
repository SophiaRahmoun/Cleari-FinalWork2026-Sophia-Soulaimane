//
//  AuthAPIService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation

final class AuthAPIService {
    static let shared = AuthAPIService()
    private init() {}
    private let baseURL = APIConfig.baseURL
    
    func login(email: String, password: String) async throws -> AuthResponse {

            try await post(endpoint: "/auth/login", body: LoginRequest(email: email, password: password))
        }

    func registerUser(
        firstName: String,
        lastName: String,
        username: String,
        email: String,
        password: String
    ) async throws -> AuthResponse {

        try await post(
            endpoint: "/auth/register-user",
            body: RegisterUserRequest(
                first_name: firstName,
                last_name: lastName,
                username: username,
                email: email,
                password: password
            )
        )
    }

    func registerDermatologist(
        firstName: String,
        lastName: String,
        username: String,
        email: String,
        password: String,
        specialization: String?,
        conventionStatus: String?,
        inamiNumber: String?,
        pronouns: String?
    ) async throws -> AuthResponse {
        try await post(
            endpoint: "/auth/register-dermatologist",
            body: RegisterDermatologistRequest(
                first_name: firstName,
                last_name: lastName,
                username: username,
                email: email,
                password: password,
                specialization: specialization,
                convention_status: conventionStatus,
                inami_number: inamiNumber,
                pronouns: pronouns
            )
        )
    }

    func fetchMe() async throws -> AuthUser {
        guard let token = TokenStorage.shared.token else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No token"])
        }
        guard let url = URL(string: baseURL + "/auth/me") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 15 // don't wait 60s for a cold Render start
        let (data, http) = try await URLSession.shared.data(for: request)
        guard let httpResponse = http as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Session expired"])
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "Auth", code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Server error \(httpResponse.statusCode)"])
        }
        let me = try JSONDecoder().decode(MeResponse.self, from: data)
        return me.user
    }

        private func post<T: Encodable, U: Decodable>(endpoint: String, body: T) async throws -> U {

            guard let url = URL(string: baseURL + endpoint) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                let backendError = String(data: data, encoding: .utf8) ?? "Unknown backend error"
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: backendError])

            }
            return try JSONDecoder().decode(U.self, from: data)
        }
}
