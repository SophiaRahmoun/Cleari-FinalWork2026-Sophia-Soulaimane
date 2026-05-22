//
//  DebunkService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 22/05/2026.
//

import Foundation

final class DebunkService {
    static let shared = DebunkService()
    private init() {}

    func fetchFakeTrendPosts() async throws -> [FakeTrendPost] {
        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/posts") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([FakeTrendPost].self, from: data)
    }
}
