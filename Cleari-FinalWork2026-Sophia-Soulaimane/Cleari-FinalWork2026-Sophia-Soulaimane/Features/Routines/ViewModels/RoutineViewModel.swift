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

    func addProduct() {
        let newProduct = RoutineProduct()
        products.append(newProduct)
    }

    func deleteProduct(_ product: RoutineProduct) {
        products.removeAll { $0.id == product.id }
    }

    func updateProductName(for product: RoutineProduct, name: String) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            return
        }

        products[index].name = name
    }
}
