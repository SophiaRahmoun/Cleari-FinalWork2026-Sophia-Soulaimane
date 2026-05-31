//
//  Dermatologist.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//


import Foundation

struct Dermatologist: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let city: String?
    let rating: Double?
    let profileImage: String?
}