//
//  RoutineViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation
import SwiftUI

final class RoutineViewModel: ObservableObject {

    @Published var products: [RoutineProduct] = []

    private let storageService = RoutineStorageService()

    init() {
        self.products = storageService.load()
    }

    func addProduct(imageData: Data? = nil) {
        let newProduct = RoutineProduct(
            imageData: imageData
        )

        products.append(newProduct)

        storageService.save(products: products)
    }

    func deleteProduct(_ product: RoutineProduct) {
        products.removeAll {
            $0.id == product.id
        }

        storageService.save(products: products)
    }

    func updateProductName(
        for product: RoutineProduct,
        name: String
    ) {
        guard let index = products.firstIndex(where: {
            $0.id == product.id
        }) else {
            return
        }

        products[index].name = name

        storageService.save(products: products)
    }

    func updateProductImage(
        for product: RoutineProduct,
        imageData: Data?
    ) {
        guard let index = products.firstIndex(where: {
            $0.id == product.id
        }) else {
            return
        }

        products[index].imageData = imageData

        storageService.save(products: products)
    }
}
