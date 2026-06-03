//
//  RoutineRequests.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

struct CreateRoutineRequest: Encodable {
    let productName: String
    let imageBase64: String?
    let usageTime: String?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case imageBase64
        case usageTime = "usage_time"
        case notes
    }
}

struct UpdateRoutineRequest: Encodable {
    let productName: String?
    let imageBase64: String?
    let usageTime: String?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case imageBase64
        case usageTime = "usage_time"
        case notes
    }
}
