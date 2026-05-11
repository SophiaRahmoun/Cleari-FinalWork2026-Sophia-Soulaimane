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
            name: "Dr. Emma Laurent",
            description: "Focused on eczema and dry skin treatments.",
            city: "Antwerp",
            gender: "Female",
            rating: 4.8,
            imageName: "ProfileSample",
            speciality: "Eczema . Dry Skin",
            experience: "8 years experience",
            availability: "Weekdays"
        ),

        Dermatologist(
            name: "Dr. Adam El Idrissi",
            description: "Experienced in acne scars and pigmentation.",
            city: "Ghent",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Acne Scars . Pigmentation",
            experience: "12 years experience",
            availability: "Flexible"
        ),

        Dermatologist(
            name: "Dr. Lina Vermeulen",
            description: "Helping patients with sensitive and reactive skin.",
            city: "Leuven",
            gender: "Female",
            rating: 4.9,
            imageName: "ProfileSample",
            speciality: "Sensitive Skin . Rosacea",
            experience: "6 years experience",
            availability: "Evenings"
        ),

        Dermatologist(
            name: "Dr. Noah Janssens",
            description: "Specialized in anti-aging and skin rejuvenation.",
            city: "Brussels",
            gender: "Male",
            rating: 4.6,
            imageName: "ProfileSample",
            speciality: "Anti-Aging . Skin Rejuvenation",
            experience: "14 years experience",
            availability: "Flexible"
        ),

        Dermatologist(
            name: "Dr. Yasmine Haddad",
            description: "Passionate about treating hormonal acne.",
            city: "Liège",
            gender: "Female",
            rating: 5.0,
            imageName: "ProfileSample",
            speciality: "Hormonal Acne . Oily Skin",
            experience: "9 years experience",
            availability: "Weekends"
        ),

        Dermatologist(
            name: "Dr. Lucas Peeters",
            description: "Expert in laser treatments and pigmentation.",
            city: "Namur",
            gender: "Male",
            rating: 4.5,
            imageName: "ProfileSample",
            speciality: "Laser Treatments . Pigmentation",
            experience: "11 years experience",
            availability: "Weekdays"
        ),

        Dermatologist(
            name: "Dr. Sofia Karim",
            description: "Dedicated to helping patients with chronic skin conditions.",
            city: "Bruges",
            gender: "Female",
            rating: 4.8,
            imageName: "ProfileSample",
            speciality: "Psoriasis . Eczema",
            experience: "7 years experience",
            availability: "Flexible"
        ),

        Dermatologist(
            name: "Dr. Elias Dubois",
            description: "Specialized in skin allergies and dermatitis.",
            city: "Mons",
            gender: "Male",
            rating: 4.7,
            imageName: "ProfileSample",
            speciality: "Dermatitis . Allergies",
            experience: "13 years experience",
            availability: "Evenings"
        ),

        Dermatologist(
            name: "Dr. Ines Moreau",
            description: "Focused on skincare routines and preventive dermatology.",
            city: "Charleroi",
            gender: "Female",
            rating: 4.9,
            imageName: "ProfileSample",
            speciality: "Preventive Care . Skincare",
            experience: "5 years experience",
            availability: "Flexible"
        ),

        Dermatologist(
            name: "Dr. Karim Van Dijk",
            description: "Experienced in treating acne and uneven skin texture.",
            city: "Mechelen",
            gender: "Male",
            rating: 4.6,
            imageName: "ProfileSample",
            speciality: "Acne . Skin Texture",
            experience: "10 years experience",
            availability: "Weekdays"
        ),
    ]
}
