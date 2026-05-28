//
//  PayementService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/05/2026.
//

import Foundation

struct CheckoutSessionResponse: Codable {
    let checkoutUrl: String
}

final class PayementService {
    static let shared = PayementService()

    private init() {}

    func createCheckoutSession(planType: String) async throws -> String {
        guard let url = URL(string: "\(APIConfig.baseURL)/payments/create-checkout-session") else {
            throw URLError(.badURL)
        }

        guard let token = TokenStorage.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = [
            "planType": planType
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            let backendError = String(data: data, encoding: .utf8) ?? "Unknown backend error"
            throw NSError(
                domain: "",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: backendError]
            )
        }

        let decodedResponse = try JSONDecoder().decode(CheckoutSessionResponse.self, from: data)
        return decodedResponse.checkoutUrl
    }
}
