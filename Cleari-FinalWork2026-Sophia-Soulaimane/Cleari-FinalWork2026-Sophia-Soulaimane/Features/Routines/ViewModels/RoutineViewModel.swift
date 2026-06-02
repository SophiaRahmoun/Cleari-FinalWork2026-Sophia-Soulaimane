//
//  RoutineViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

final class RoutineViewModel: ObservableObject {
    @Published var products: [RoutineProduct] = []
    @Published var errorMessage: String?

    private let apiService = RoutineAPIService.shared

    init() {
        loadRoutines()
    }

    func loadRoutines() {
        Task {
            do {
                let routines = try await apiService.fetchRoutines()

                await MainActor.run {
                    self.products = routines.map { RoutineProduct(dto: $0) }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func addProduct(imageData: Data? = nil) {
        Task {
            do {
                let request = CreateRoutineRequest(
                    productName: "Product name",
                    imageBase64: imageData?.toBase64ImageString(),
                    usageTime: nil,
                    notes: nil
                )

                let dto = try await apiService.createRoutine(request)

                await MainActor.run {
                    self.products.insert(RoutineProduct(dto: dto), at: 0)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func deleteProduct(_ product: RoutineProduct) {
        Task {
            do {
                try await apiService.deleteRoutine(id: product.id)

                await MainActor.run {
                    self.products.removeAll { $0.id == product.id }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateProductName(for product: RoutineProduct, name: String) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            return
        }

        products[index].name = name

        Task {
            do {
                let request = UpdateRoutineRequest(
                    productName: name,
                    imageBase64: nil,
                    usageTime: nil,
                    notes: nil
                )

                _ = try await apiService.updateRoutine(
                    id: product.id,
                    requestBody: request
                )
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateProductImage(for product: RoutineProduct, imageData: Data?) {
        Task {
            do {
                let request = UpdateRoutineRequest(
                    productName: nil,
                    imageBase64: imageData?.toBase64ImageString(),
                    usageTime: nil,
                    notes: nil
                )

                let dto = try await apiService.updateRoutine(
                    id: product.id,
                    requestBody: request
                )

                await MainActor.run {
                    guard let index = self.products.firstIndex(where: { $0.id == product.id }) else {
                        return
                    }

                    self.products[index] = RoutineProduct(dto: dto)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

private extension Data {
    func toBase64ImageString() -> String {
        "data:image/jpeg;base64,\(self.base64EncodedString())"
    }
}
