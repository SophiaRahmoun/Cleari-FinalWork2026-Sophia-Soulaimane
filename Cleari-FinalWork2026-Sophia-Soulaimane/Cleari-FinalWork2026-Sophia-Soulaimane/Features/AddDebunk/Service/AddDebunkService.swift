//
//  AddDebunkService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 21/05/2026.
//

import Foundation

final class AddDebunkService {
    static let shared = AddDebunkService()

    private init() {}

    func createDebunkPost(
        title: String,
        trendName: String,
        description: String,
        debunkExplanation: String,
        tiktokUrl: String?,
        status: String?
    ) async throws {

        guard let url = URL(string: "\(APIConfig.baseURL)/fake-trends/posts") else {
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
            "title": title,
            "trendName": trendName,
            "description": description,
            "debunkExplanation": debunkExplanation,
            "tiktokUrl": tiktokUrl ?? "",
            "status": "published"
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard 200..<300 ~= httpResponse.statusCode else {

            let backendError = String(data: data, encoding: .utf8) ?? "Unknown backend error"

            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: backendError]
            )
        }

        print("DEBUNK POST CREATED SUCCESSFULLY")
    }
}
