//
//  ConsultationFormViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import Foundation

@MainActor
final class ConsultationFormViewModel: ObservableObject {
    @Published var formData = ConsultationFormData()
    @Published var currentStep: Int = 1
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func goToNextStep() {
        if currentStep < 3 {
            currentStep += 1
        }
    }

    func goToPreviousStep() {
        if currentStep > 1 {
            currentStep -= 1
        }
    }

    var canGoNextFromStepOne: Bool {
        formData.skinFeeling != nil &&
        formData.productReaction != nil &&
        formData.flakiness != nil
    }

    var canGoNextFromStepTwo: Bool {
        formData.diagnosedCondition != nil &&
        formData.hasAllergies != nil &&
        formData.hasSkinIssues != nil
    }

    var canSubmit: Bool {
        formData.mainConcern != nil &&
        formData.wantsPhotoUpload != nil &&
        formData.consentShared != nil 
        
    }

    func submitForm() async {
        isLoading = true
        errorMessage = nil

        do {
            let token = "TON_TOKEN_ICI"

            try await SkinFormService.shared.submitSkinForm(
                formData: formData,
                token: token
            )

            print("Skin form saved successfully")
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            print("Error:", error.localizedDescription)
            isLoading = false
        }
    }
}
