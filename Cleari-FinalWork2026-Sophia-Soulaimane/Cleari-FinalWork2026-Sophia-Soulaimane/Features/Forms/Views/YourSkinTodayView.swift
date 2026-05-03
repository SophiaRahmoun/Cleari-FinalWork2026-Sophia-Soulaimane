//
//  YourSkinTodayView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct YourSkinTodayView: View {
    @ObservedObject var viewModel: ConsultationFormViewModel

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                VStack(alignment: .leading, spacing: 58) {
                    questionEight
                    questionNine
                    privacyChecks
                }
                .padding(.horizontal, 42)
                .padding(.top, 65)

                Spacer()

                SecondaryButton(title: "CONFIRM") {
                    Task {
                        await viewModel.submitForm()
                    }
                }
                .padding(.horizontal, 100)
                .padding(.bottom, 42)
            }
        }
    }
}

extension YourSkinTodayView {
    private var header: some View {
        VStack(spacing: 12) {
            Text("Your skin today")
                .font(AppFont.gillSwiftUI(.regular, size: 36))
                .foregroundColor(Color(hex: "1A1018"))

            HStack(spacing: 6) {
                Capsule().fill(Color(hex: "1A1018")).frame(width: 78, height: 6)
                Capsule().fill(Color(hex: "1A1018")).frame(width: 78, height: 6)
                Capsule().fill(Color(hex: "1A1018")).frame(width: 78, height: 6)
            }

            Text("Help us understand your current situation better.")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 55)
    }
}

extension YourSkinTodayView {
    private var questionEight: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("8)   What is your main concern today?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    concernButton("Pimple / Acne")
                    concernButton("Redness/Sensitivity")
                }

                HStack(spacing: 10) {
                    concernButton("Dryness / Tightness")
                    concernButton("Uneven tone / Dark spots")
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func concernButton(_ title: String) -> some View {
        Button {
            viewModel.formData.mainConcern = title
        } label: {
            FormChoicePill(
                title: title,
                isSelected: viewModel.formData.mainConcern == title
            )
        }
    }
}

extension YourSkinTodayView {
    private var questionNine: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("9)   Would you like to upload photos\nof your skin?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button {
                viewModel.formData.wantsPhotoUpload = "Yes"
            } label: {
                FormCheckbox(
                    title: "Yes",
                    isSelected: viewModel.formData.wantsPhotoUpload == "Yes"
                )
            }

            Button {
                viewModel.formData.wantsPhotoUpload = "Not sure"
            } label: {
                FormCheckbox(
                    title: "Not sure",
                    isSelected: viewModel.formData.wantsPhotoUpload == "Not sure"
                )
            }
        }
        .buttonStyle(.plain)
    }
}

extension YourSkinTodayView {
    private var privacyChecks: some View {
        VStack(alignment: .leading, spacing: 22) {
            Button {
                viewModel.formData.optionalPhotosAccepted.toggle()
            } label: {
                FormCheckbox(
                    title: "Photos are optional and only shared with\ncertified dermatologists",
                    isSelected: viewModel.formData.optionalPhotosAccepted
                )
            }

            Button {
                viewModel.formData.consentShared.toggle()
            } label: {
                FormCheckbox(
                    title: "I agree to share this information only with\ncertified dermatologists for consultation\npurposes",
                    isSelected: viewModel.formData.consentShared
                )
            }
        }
        .buttonStyle(.plain)
    }
}
