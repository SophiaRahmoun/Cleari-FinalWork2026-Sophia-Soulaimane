//
//  RoutineStorageService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

final class RoutineStorageService {
    private let storageKey = "saved_routine_products"

    func save(products: [RoutineProduct]) {
        guard let encoded = try? JSONEncoder().encode(products) else {
            return
        }

        UserDefaults.standard.set(encoded, forKey: storageKey)
    }

    func load() -> [RoutineProduct] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        guard let products = try? JSONDecoder().decode([RoutineProduct].self, from: data) else {
            return []
        }

        return products
    }
}
