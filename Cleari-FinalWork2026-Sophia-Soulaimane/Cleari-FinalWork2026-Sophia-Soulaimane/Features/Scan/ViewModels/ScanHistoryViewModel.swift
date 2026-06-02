//
//  ScanHistoryViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import Foundation

@MainActor
final class ScanHistoryViewModel: ObservableObject {
    @Published var scans: [ScanHistoryRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = SkinScanService()

    func fetchHistory() async {
        isLoading = true
        errorMessage = nil
        do {
            scans = try await service.fetchHistory()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
