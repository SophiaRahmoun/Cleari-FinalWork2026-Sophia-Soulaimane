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
    @Published var showError: Bool = false

    private let apiService = RoutineAPIService.shared
    private let storage = RoutineStorageService()

    init() {
        loadRoutines()
    }

    func loadRoutines() {
        // Load local cache immediately so the UI is responsive
        products = storage.load()

        Task {
            do {
                let routines = try await apiService.fetchRoutines()

                await MainActor.run {
                    self.products = routines.map { RoutineProduct(dto: $0) }
                    self.storage.save(products: self.products)
                }
            } catch {
                // Keep local data visible, just log the error silently
                print("[Routine] fetchRoutines failed: \(error.localizedDescription)")
            }
        }
    }

    func addProduct(imageData: Data? = nil) {
        // Optimistic local insert with a temp negative id
        let tempId = -(Int(Date().timeIntervalSince1970))
        let tempProduct = RoutineProduct(
            id: tempId,
            name: "Product name",
            imageData: imageData,
            imageUrl: nil
        )

        products.insert(tempProduct, at: 0)
        storage.save(products: products)

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
                    // Replace temp entry with the real one from server
                    if let index = self.products.firstIndex(where: { $0.id == tempId }) {
                        self.products[index] = RoutineProduct(dto: dto)
                    }
                    self.storage.save(products: self.products)
                }
            } catch {
                await MainActor.run {
                    // Keep the local product visible but show the error
                    self.errorMessage = "Could not sync with server: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }

    func deleteProduct(_ product: RoutineProduct) {
        // Optimistic local delete
        products.removeAll { $0.id == product.id }
        storage.save(products: products)

        guard product.id > 0 else { return } // temp product, no server call needed

        Task {
            do {
                try await apiService.deleteRoutine(id: product.id)
            } catch {
                await MainActor.run {
                    // Restore the product if delete failed
                    self.products.append(product)
                    self.storage.save(products: self.products)
                    self.errorMessage = "Could not delete: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }

    func updateProductName(for product: RoutineProduct, name: String) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            return
        }

        products[index].name = name
        storage.save(products: products)

        guard product.id > 0 else { return } // temp product

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
                print("[Routine] updateProductName failed: \(error.localizedDescription)")
            }
        }
    }

    func updateProductImage(for product: RoutineProduct, imageData: Data?) {
        // Optimistic local update
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].imageData = imageData
            storage.save(products: products)
        }

        guard product.id > 0 else { return } // temp product

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
                    if let index = self.products.firstIndex(where: { $0.id == product.id }) {
                        self.products[index] = RoutineProduct(dto: dto)
                        self.storage.save(products: self.products)
                    }
                }
            } catch {
                print("[Routine] updateProductImage failed: \(error.localizedDescription)")
            }
        }
    }
}

private extension Data {
    func toBase64ImageString() -> String {
        "data:image/jpeg;base64,\(self.base64EncodedString())"
    }
}
