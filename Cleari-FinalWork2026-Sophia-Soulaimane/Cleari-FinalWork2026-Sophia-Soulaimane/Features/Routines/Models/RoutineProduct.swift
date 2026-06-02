//
//  RoutineProduct.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

struct RoutineProduct: Identifiable, Codable {
    let id: UUID
    var name: String
    var imageData: Data?

    init(
        id: UUID = UUID(),
        name: String = "",
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.imageData = imageData
    }
}
