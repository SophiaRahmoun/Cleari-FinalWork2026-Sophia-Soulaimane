//
//  RoutineAPIService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

final class RoutineAPIService {
    static let shared = RoutineAPIService()
    private init() {}

    private let baseURL = APIConfig.baseURL

    func fetchRoutines() async throws -> [RoutineDTO] {
        try await request(
            endpoint: "/routines",
            method: "GET"
        )
    }

    func createRoutine(_ requestBody: CreateRoutineRequest) async throws -> RoutineDTO {
        let response: RoutineResponse = try await request(
            endpoint: "/routines",
            method: "POST",
            body: requestBody
        )

        return response.routine
    }

    func updateRoutine(
        id: Int,
        requestBody: UpdateRoutineRequest
    ) async throws -> RoutineDTO {
        let response: RoutineResponse = try await request(
            endpoint: "/routines/\(id)",
            method: "PUT",
            body: requestBody
        )

        return response.routine
    }

    func deleteRoutine(id: Int) async throws {
        let _: EmptyResponse = try await request(
            endpoint: "/routines/\(id)",
            method: "DELETE"
        )
    }

    private func request<T: Decodable>(
        endpoint: String,
        method: String
    ) async throws -> T {
        try await request(
            endpoint: endpoint,
            method: method,
            body: Optional<String>.none
        )
    }

    private func request<T: Decodable, Body: Encodable>(
        endpoint: String,
        method: String,
        body: Body?
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

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

        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct RoutineResponse: Decodable {
    let routine: RoutineDTO
}

struct EmptyResponse: Decodable {}
