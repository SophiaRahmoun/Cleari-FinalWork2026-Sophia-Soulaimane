//
//  RoutineProduct.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

struct RoutineProduct: Identifiable, Codable {
    let id: Int
    var name: String
    var imageData: Data?
    var imageUrl: String?

    init(
        id: Int,
        name: String = "",
        imageData: Data? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.imageUrl = imageUrl
    }

    init(dto: RoutineDTO) {
        self.id = dto.id
        self.name = dto.productName
        self.imageData = nil
        self.imageUrl = dto.productImageUrl
    }
}
