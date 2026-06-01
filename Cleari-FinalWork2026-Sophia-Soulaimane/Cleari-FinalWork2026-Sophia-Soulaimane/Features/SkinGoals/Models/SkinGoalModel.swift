//
//  SkinGoalModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import Foundation

struct SkinGoalResponse: Codable {
    let description: String
    let selectedGoals: [String]
}

struct SaveSkinGoalRequest: Codable {
    let description: String
    let selectedGoals: [String]
}
