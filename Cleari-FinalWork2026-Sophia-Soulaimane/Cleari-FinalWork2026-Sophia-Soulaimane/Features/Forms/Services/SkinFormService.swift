//
//  SkinFormService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 05/05/2026.
//

import Foundation

final class SkinFormService {
    
    func submitSkinForm(data: ConsultationFormData) async throws {
        guard let url = URL(string: "http://localhost:3000/api/skin-form") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            let message = String(data: responseData, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: message
            ])
        }
    }
}
