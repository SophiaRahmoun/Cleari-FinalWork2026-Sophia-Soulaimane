//
//  YourSkinTodayView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct YourSkinTodayView: View {
    @State private var selectedConcern: String?
    @State private var uploadPhotosAnswer: String?
    @State private var optionalPhotosChecked = false
    @State private var consentChecked = false

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
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
                    print("Confirm tapped")
                }
                .padding(.horizontal, 100)
                .padding(.bottom, 42)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text("Your skin today")
                .font(AppFont.gillSwiftUI(.regular, size: 36))
                .foregroundColor(Color(hex: "1A1018"))

            HStack(spacing: 6) {
                Capsule()
                    .fill(Color(hex: "1A1018"))
                    .frame(width: 78, height: 6)

                Capsule()
                    .fill(Color(hex: "1A1018"))
                    .frame(width: 78, height: 6)

                Capsule()
                    .fill(Color(hex: "1A1018"))
                    .frame(width: 78, height: 6)
            }

            Text("Help us understand your current situation better.")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 55)
    }

    private var questionEight: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("8)   What is your main concern today?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Button {
                        selectedConcern = "Pimple / Acne"
                    } label: {
                        FormChoicePill(
                            title: "Pimple / Acne",
                            isSelected: selectedConcern == "Pimple / Acne"
                        )
                    }

                    Button {
                        selectedConcern = "Redness/Sensitivity"
                    } label: {
                        FormChoicePill(
                            title: "Redness/Sensitivity",
                            isSelected: selectedConcern == "Redness/Sensitivity"
                        )
                    }
                }

                HStack(spacing: 10) {
                    Button {
                        selectedConcern = "Dryness / Tightness"
                    } label: {
                        FormChoicePill(
                            title: "Dryness / Tightness",
                            isSelected: selectedConcern == "Dryness / Tightness"
                        )
                    }

                    Button {
                        selectedConcern = "Uneven tone / Dark spots"
                    } label: {
                        FormChoicePill(
                            title: "Uneven tone / Dark spots",
                            isSelected: selectedConcern == "Uneven tone / Dark spots"
                        )
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var questionNine: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("9)   Would you like to upload photos\nof your skin?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button {
                uploadPhotosAnswer = "Yes"
            } label: {
                FormCheckbox(title: "Yes", isSelected: uploadPhotosAnswer == "Yes")
            }

            Button {
                uploadPhotosAnswer = "Not sure"
            } label: {
                FormCheckbox(title: "Not sure", isSelected: uploadPhotosAnswer == "Not sure")
            }
        }
        .buttonStyle(.plain)
    }

    private var privacyChecks: some View {
        VStack(alignment: .leading, spacing: 22) {
            Button {
                optionalPhotosChecked.toggle()
            } label: {
                FormCheckbox(
                    title: "Photos are optional and only shared with\ncertified dermatologists",
                    isSelected: optionalPhotosChecked
                )
            }

            Button {
                consentChecked.toggle()
            } label: {
                FormCheckbox(
                    title: "I agree to share this information only with\ncertified dermatologists for consultation\npurposes",
                    isSelected: consentChecked
                )
            }
        }
        .buttonStyle(.plain)
    }
}
