//
//  SkinScanService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation
import UIKit

final class SkinScanService {
    func uploadSkinScan(image: UIImage) async throws -> SkinScanResponse {
           guard let token = TokenStorage.shared.token else {
               throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No auth token found"])
           }

           guard let url = URL(string: APIConfig.baseURL + "/skin-scan/analyze") else {
               throw URLError(.badURL)
           }

           guard let imageData = image.jpegData(compressionQuality: 0.6) else {
               throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])
           }

           let boundary = UUID().uuidString
        
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

           var body = Data()
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"image\"; filename=\"scan.jpg\"\r\n".data(using: .utf8)!)
           body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
           body.append(imageData)
           body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

           request.httpBody = body

           let (data, response) = try await URLSession.shared.data(for: request)
           guard let httpResponse = response as? HTTPURLResponse,
                 200..<300 ~= httpResponse.statusCode else {
               struct BackendError: Decodable { let message: String }
               if let parsed = try? JSONDecoder().decode(BackendError.self, from: data) {
                   throw NSError(domain: "SkinScan", code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                                 userInfo: [NSLocalizedDescriptionKey: parsed.message])
               }
               let raw = String(data: data, encoding: .utf8) ?? "Upload failed"
               throw NSError(domain: "SkinScan", code: 0, userInfo: [NSLocalizedDescriptionKey: raw])
           }

           return try JSONDecoder().decode(SkinScanResponse.self, from: data)
       }

    func fetchHistory() async throws -> [ScanHistoryRecord] {
        guard let token = TokenStorage.shared.token else {
            throw NSError(domain: "SkinScan", code: 401, userInfo: [NSLocalizedDescriptionKey: "No auth token found"])
        }
        guard let url = URL(string: APIConfig.baseURL + "/skin-scan/history") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ScanHistoryResponse.self, from: data)
        return response.scans
    }
}
