//
//  SkinScanViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/04/2026.
//

import Foundation
import UIKit

@MainActor
final class SkinScanViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var scanResult: SkinScan?
    @Published var scanImageUrl: String?   // Cloudinary URL from analysis.image_url
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = SkinScanService()

    func analyzeSelectedImage() async {
        guard let selectedImage else {
            errorMessage = "Please select an image first."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.uploadSkinScan(image: selectedImage)
            scanResult   = response.scan
            scanImageUrl = response.analysis?.imageUrl
            print("[SkinScan] Skin type: \(response.scan.recommendation.skinTypeEstimate ?? "unknown")")
            print("[SkinScan] Cloudinary URL: \(scanImageUrl ?? "none")")
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
