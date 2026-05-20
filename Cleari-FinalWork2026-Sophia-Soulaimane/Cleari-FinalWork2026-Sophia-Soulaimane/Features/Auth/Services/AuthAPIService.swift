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

        func registerUser(username: String, email: String, password: String) async throws -> AuthResponse {

            try await post(endpoint: "/auth/register-user", body: RegisterUserRequest(username: username, email: email, password: password))
        }

        func registerDermatologist(username: String, email: String, password: String, licenseNumber: String? = nil) async throws -> AuthResponse {

            try await post(endpoint: "/auth/register-dermatologist", body: RegisterDermatologistRequest(username: username, email: email, password: password, specialization: "Dermatology", license_number: licenseNumber, bio: nil))

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
