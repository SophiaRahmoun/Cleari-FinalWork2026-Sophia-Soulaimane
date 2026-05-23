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
        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/feed") else {
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
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let feedResponse = try JSONDecoder().decode(FakeTrendFeedResponse.self, from: data)
        return feedResponse.posts
    }

    func likeFakeTrendPost(postId: Int) async throws -> FakeTrendLikeResponse {
        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/posts/\(postId)/like") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(FakeTrendLikeResponse.self, from: data)
    }

    func unlikeFakeTrendPost(postId: Int) async throws -> FakeTrendLikeResponse {
        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/posts/\(postId)/like") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(FakeTrendLikeResponse.self, from: data)
    }
    func fetchComments(postId: Int) async throws -> [FakeTrendComment] {

        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/posts/\(postId)/comments") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([FakeTrendComment].self, from: data)
    }

    func createComment(
        postId: Int,
        content: String
    ) async throws {

        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/posts/\(postId)/comments") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "content": content
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
    }
}
