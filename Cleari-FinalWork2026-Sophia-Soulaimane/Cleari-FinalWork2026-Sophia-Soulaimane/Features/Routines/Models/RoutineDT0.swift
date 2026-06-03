//
//  RoutineDT0.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

struct RoutineDTO: Decodable {
    let id: Int
    let userId: Int
    let productName: String
    let productImageUrl: String?
    let usageTime: String?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case productName = "product_name"
        case productImageUrl = "product_image_url"
        case usageTime = "usage_time"
        case notes
    }
}
