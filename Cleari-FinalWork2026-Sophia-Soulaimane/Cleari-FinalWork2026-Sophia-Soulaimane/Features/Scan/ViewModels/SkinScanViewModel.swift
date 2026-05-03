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
            scanResult = response.scan
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
