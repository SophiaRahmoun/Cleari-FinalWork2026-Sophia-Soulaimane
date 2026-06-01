//
//  DermatologistService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//


import Foundation

final class DermatologistService {
    static let shared = DermatologistService()

    private let baseURL = "\(APIConfig.baseURL)/dermatologists"

    private init() {}

    func fetchDermatologists() async throws -> [Dermatologist] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Dermatologist].self, from: data)
    }
}