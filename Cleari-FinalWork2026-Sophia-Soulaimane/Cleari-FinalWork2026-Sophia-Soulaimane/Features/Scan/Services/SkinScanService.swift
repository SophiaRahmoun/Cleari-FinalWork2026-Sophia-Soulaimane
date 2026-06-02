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

           guard let imageData = image.jpegData(compressionQuality: 0.8) else {
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
               let backendError = String(data: data, encoding: .utf8) ?? "Upload failed"
               throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: backendError])

           }

           return try JSONDecoder().decode(SkinScanResponse.self, from: data)

       }

   }
