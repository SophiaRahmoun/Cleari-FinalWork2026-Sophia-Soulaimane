//
//  DermatologistEarningsService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 03/06/2026.
//

import Foundation

final class DermatologistEarningsService {
    static let shared = DermatologistEarningsService()
    private init() {}

    func fetchEarnings() async throws -> DermatologistEarningsResponse {
        guard let url = URL(string: APIConfig.baseURL + "/fake-trends/my-earnings") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            let body = String(data: data, encoding: .utf8) ?? "no body"
            throw NSError(
                domain: "EarningsAPI",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(body)"]
            )
        }

        return try JSONDecoder().decode(DermatologistEarningsResponse.self, from: data)
    }
}
