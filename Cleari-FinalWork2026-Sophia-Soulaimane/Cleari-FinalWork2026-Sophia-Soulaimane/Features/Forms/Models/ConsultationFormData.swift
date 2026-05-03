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
    var wantsPhotoUpload: String?
    var consentShared: Bool

    init(
        skinFeeling: String? = nil,
        productReaction: String? = nil,
        flakiness: String? = nil,
        diagnosedCondition: String? = nil,
        hasAllergies: String? = nil,
        allergiesDetails: String = "",
        hasSkinIssues: String? = nil,
        mainConcern: String? = nil,
        wantsPhotoUpload: String? = nil,
        consentShared: Bool = false
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
    }
}
