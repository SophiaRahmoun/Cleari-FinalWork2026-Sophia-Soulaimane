//
//  ConsultationFormView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct ConsultationFormView: View {
    @StateObject private var viewModel = ConsultationFormViewModel()

    var body: some View {
        Group {
            switch viewModel.currentStep {
            case 1:
                KnowYourSkinView(viewModel: viewModel)

            case 2:
                YourSkinHistoryView(viewModel: viewModel)

            case 3:
                YourSkinTodayView(viewModel: viewModel)

            default:
                KnowYourSkinView(viewModel: viewModel)
            }
        }
    }
}
