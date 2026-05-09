//
//  Dermatologist.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 09/05/2026.
//

import Foundation

struct Dermatologist: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let city: String
    let gender: String
    let rating: Double
    let imageName: String
    let speciality: String
    let experience: String
    let availability: String
}

extension Dermatologist {
    static let mockDermatologists: [Dermatologist] = [
        Dermatologist(
            name: "Dr. Sarah Ben Ali",
            description: "Specialized in acne and sensitive skin.",
            city: "Brussels",
            gender: "Female",
            rating: 4.9,
            imageName: "ProfileSample",
            speciality: "Acne . Rosacea",
            experience: "10 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Halioui Saïd",
            description: "Focused on skin inflammation and routines.",
            city: "Brussels",
            gender: "Male",
            rating: 4.8,
            imageName: "ProfileSample",
            speciality: "Sensitive skin",
            experience: "8 years experience",
            availability: "Available this week"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
            
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
        Dermatologist(
            name: "Dr. Stefan Tilburgs",
            description: "Expert in pigmentation and skin concerns.",
            city: "Antwerp",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Hyperpigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),
    ]
}
