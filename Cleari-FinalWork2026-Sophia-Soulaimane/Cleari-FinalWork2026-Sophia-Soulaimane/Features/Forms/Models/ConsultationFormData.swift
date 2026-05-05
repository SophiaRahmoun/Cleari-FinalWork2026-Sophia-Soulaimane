//
//  ConsultationFormData.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 03/05/2026.
//

// stock the answers from the form

import Foundation

struct ConsultationFormData: Codable {

    var skinFeeling: String?
    var productReaction: String?
    var flakiness: String?
    var diagnosedCondition: String?
    var hasAllergies: String?
    var allergiesDetails: String
    var hasSkinIssues: String?
    var mainConcern: String?
    var wantsPhotoUpload: Bool?
    var consentShared: Bool?
    var stepCompleted: Int?

    enum CodingKeys: String, CodingKey {
        case skinFeeling = "skin_feeling"
        case productReaction = "product_reaction"
        case flakiness
        case diagnosedCondition = "diagnosed_condition"
        case hasAllergies = "has_allergies"
        case allergiesDetails = "allergies_details"
        case hasSkinIssues = "has_skin_issues"
        case mainConcern = "main_concern"
        case wantsPhotoUpload = "wants_photo_upload"
        case consentShared = "consent_shared"
        case stepCompleted = "step_completed"
    }

    init(
        skinFeeling: String? = nil,
        productReaction: String? = nil,
        flakiness: String? = nil,
        diagnosedCondition: String? = nil,
        hasAllergies: String? = nil,
        allergiesDetails: String = "",
        hasSkinIssues: String? = nil,
        mainConcern: String? = nil,
        wantsPhotoUpload: Bool? = nil,
        consentShared: Bool? = nil,
        stepCompleted: Int? = nil
    ) {
        self.skinFeeling = skinFeeling
        self.productReaction = productReaction
        self.flakiness = flakiness
        self.diagnosedCondition = diagnosedCondition
        self.hasAllergies = hasAllergies
        self.allergiesDetails = allergiesDetails
        self.hasSkinIssues = hasSkinIssues
        self.mainConcern = mainConcern
        self.wantsPhotoUpload = wantsPhotoUpload
        self.consentShared = consentShared
        self.stepCompleted = stepCompleted
    }
}
