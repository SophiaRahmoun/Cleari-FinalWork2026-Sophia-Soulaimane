//
//  YourSkinHistoryView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI
struct YourSkinHistoryView: View {
    @ObservedObject var viewModel: ConsultationFormViewModel

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                VStack(alignment: .leading, spacing: 34) {
                    questionFour
                    questionFive
                    questionSix
                    questionSeven
                }
                .padding(.horizontal, 42)
                .padding(.top, 58)

                Spacer()

                PrimaryButton(title: "NEXT") {
                    viewModel.goToNextStep()
                }
                .padding(.horizontal, 100)
                .padding(.bottom, 34)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text("Your skin history")
                .font(AppFont.gillSwiftUI(.regular, size: 36))
                .foregroundColor(Color(hex: "1A1018"))

            HStack(spacing: 6) {
                Capsule().fill(Color(hex: "1A1018")).frame(width: 78, height: 6)
                Capsule().fill(Color(hex: "1A1018")).frame(width: 78, height: 6)
                Capsule().fill(Color.white).frame(width: 78, height: 6)
            }

            Text("Health-related insights for the dermatologist.")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 55)
    }
    // Question 4
    private var questionFour: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("4)   Have you ever been diagnosed\nwith a skin condition?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button {
                viewModel.formData.diagnosedCondition = "Yes"
            } label: {
                FormCheckbox(
                    title: "Yes",
                    isSelected: viewModel.formData.diagnosedCondition == "Yes"
                )
            }

            Button {
                viewModel.formData.diagnosedCondition = "Not sure"
            } label: {
                FormCheckbox(
                    title: "Not sure",
                    isSelected: viewModel.formData.diagnosedCondition == "Not sure"
                )
            }
        }
        .buttonStyle(.plain)
    }

    //Question 5
    private var questionFive: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5)   Do you have any known allergies?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button {
                viewModel.formData.hasAllergies = "Yes"
            } label: {
                FormCheckbox(
                    title: "Yes",
                    isSelected: viewModel.formData.hasAllergies == "Yes"
                )
            }

            Button {
                viewModel.formData.hasAllergies = "Not sure"
            } label: {
                FormCheckbox(
                    title: "Not sure",
                    isSelected: viewModel.formData.hasAllergies == "Not sure"
                )
            }
        }
        .buttonStyle(.plain)
    }

    // Question 6
    private var questionSix: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("6)   If yes, which ones")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            FormTextBox(text: Binding(
                get: { viewModel.formData.allergiesDetails },
                set: { viewModel.formData.allergiesDetails = $0 }
            ))
        }
    }

    // Question 7
    private var questionSeven: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7)   Have you noticed any spots, rashes, or\nlesions recently?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button {
                viewModel.formData.hasSkinIssues = "Yes"
            } label: {
                FormCheckbox(
                    title: "Yes",
                    isSelected: viewModel.formData.hasSkinIssues == "Yes"
                )
            }

            Button {
                viewModel.formData.hasSkinIssues = "No"
            } label: {
                FormCheckbox(
                    title: "No",
                    isSelected: viewModel.formData.hasSkinIssues == "No"
                )
            }
        }
        .buttonStyle(.plain)
    }
}
