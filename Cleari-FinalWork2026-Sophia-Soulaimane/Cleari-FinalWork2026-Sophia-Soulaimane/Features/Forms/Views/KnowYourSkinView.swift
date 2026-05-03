//
//  KnowYourSkinView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct KnowYourSkinView: View {
    @ObservedObject var viewModel: ConsultationFormViewModel

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                VStack(alignment: .leading, spacing: 26) {
                    questionOne
                    questionTwo
                    questionThree
                }
                .padding(.horizontal, 38)
                .padding(.top, 42)

                Spacer()

                PrimaryButton(title: "NEXT") {
                    print("Next tapped")
                }
                .padding(.horizontal, 100)
                .padding(.bottom, 34)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text("Know your skin")
                .font(AppFont.gillSwiftUI(.regular, size: 36))
                .foregroundColor(Color(hex: "1A1018"))

            HStack(spacing: 6) {
                Capsule()
                    .fill(Color(hex: "1A1018"))
                    .frame(width: 78, height: 6)

                Capsule()
                    .fill(Color.white)
                    .frame(width: 78, height: 6)

                Capsule()
                    .fill(Color.white)
                    .frame(width: 78, height: 6)
            }

            Text("Help us understand how you\nskin usually feels.")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 55)
    }
    
    // question 1

    private var questionOne: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("1)   How does your skin usually feel\na few hours after washing?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            HStack(spacing: 12) {
                Button {
                    viewModel.formData.skinFeeling = "Dry / Tight"
                } label: {
                    FormImageChoiceRow(
                        imageName: "skin_dry",
                        title: "Dry/ Tight",
                        isSelected: viewModel.formData.skinFeeling == "Dry / Tight"
                    )
                }

                Button {
                    viewModel.formData.skinFeeling = "Comfortable"
                } label: {
                    FormImageChoiceRow(
                        imageName: "skin_comfortable",
                        title: "Comfortable",
                        isSelected: viewModel.formData.skinFeeling == "Comfortable"
                    )
                }

                Button {
                    viewModel.formData.skinFeeling = "Shiny on T-zone"
                } label: {
                    FormImageChoiceRow(
                        imageName: "skin_shiny_tzone",
                        title: "Shiny\non T-zone",
                        isSelected: viewModel.formData.skinFeeling == "Shiny on T-zone"
                    )
                }

                Button {
                    viewModel.formData.skinFeeling = "Shiny all over"
                } label: {
                    FormImageChoiceRow(
                        imageName: "skin_shiny_all",
                        title: "Shiny\nall over",
                        isSelected: viewModel.formData.skinFeeling == "Shiny all over"
                    )
                }
            }
            .buttonStyle(.plain)
        }
    }
    
// question 2
    private var questionTwo: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("2)   How does your skin react to new products?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button { viewModel.formData.productReaction = "Often reacts" } label: {
                FormCheckbox(title: "Often reacts (redness, burning, itching)", isSelected: viewModel.formData.productReaction == "Often reacts")
            }

            Button { viewModel.formData.productReaction = "Sometimes reacts" } label: {
                FormCheckbox(title: "Sometimes reacts", isSelected: viewModel.formData.productReaction == "Sometimes reacts")
            }

            Button { viewModel.formData.productReaction = "Rarely reacts" } label: {
                FormCheckbox(title: "Rarely reacts", isSelected: viewModel.formData.productReaction == "Rarely reacts")
            }

            Button { viewModel.formData.productReaction = "I’m not sure" } label: {
                FormCheckbox(title: "I’m not sure", isSelected: viewModel.formData.productReaction == "I’m not sure")
            }
        }
        .buttonStyle(.plain)
    }
    
    // question 3

    private var questionThree: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("3)   Do you notice flakiness or rough areas?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button { viewModel.formData.flakiness = "Yes" } label: {
                FormCheckbox(title: "Yes", isSelected: viewModel.formData.flakiness == "Yes")
            }

            Button { viewModel.formData.flakiness = "No" } label: {
                FormCheckbox(title: "No", isSelected: viewModel.formData.flakiness == "No")
            }

            Button { viewModel.formData.flakiness = "Sometimes" } label: {
                FormCheckbox(title: "Sometimes", isSelected: viewModel.formData.flakiness == "Sometimes")
            }
        }
        .buttonStyle(.plain)
    }
}
