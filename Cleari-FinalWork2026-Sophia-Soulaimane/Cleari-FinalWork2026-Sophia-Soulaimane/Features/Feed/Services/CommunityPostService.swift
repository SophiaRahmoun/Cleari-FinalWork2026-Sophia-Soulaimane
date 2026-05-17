//
//  CommunityPostService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 17/05/2026.
//

import Foundation

final class CommunityPostService {

    static let shared = CommunityPostService()

    private init() {}

    func fetchPosts() async throws -> [CommunityPost] {

        guard let url = URL(string: "http://localhost:4000/api/community/posts") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()

        return try decoder.decode([CommunityPost].self, from: data)
    }
}
