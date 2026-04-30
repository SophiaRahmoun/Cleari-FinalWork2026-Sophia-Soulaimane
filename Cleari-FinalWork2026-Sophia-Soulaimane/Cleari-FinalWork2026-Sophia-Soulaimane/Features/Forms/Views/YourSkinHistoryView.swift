//
//  YourSkinHistoryView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct YourSkinHistoryView: View {
    @State private var diagnosedAnswer: String?
    @State private var allergiesAnswer: String?
    @State private var lesionsAnswer: String?
    @State private var allergiesDetails: String = ""

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
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
                    print("Next tapped")
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
                Capsule()
                    .fill(Color(hex: "1A1018"))
                    .frame(width: 78, height: 6)

                Capsule()
                    .fill(Color(hex: "1A1018"))
                    .frame(width: 78, height: 6)

                Capsule()
                    .fill(Color.white)
                    .frame(width: 78, height: 6)
            }

            Text("Health-related insights for the dermatologist.")
                .font(AppFont.gillSwiftUI(.bold, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 55)
    }

    private var questionFour: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("4)   Have you ever been diagnosed\nwith a skin in condition?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button { diagnosedAnswer = "Yes" } label: {
                FormCheckbox(title: "Yes", isSelected: diagnosedAnswer == "Yes")
            }

            Button { diagnosedAnswer = "Not sure" } label: {
                FormCheckbox(title: "Not sure", isSelected: diagnosedAnswer == "Not sure")
            }
        }
        .buttonStyle(.plain)
    }

    private var questionFive: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5)   Do you have any know any know allergies?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button { allergiesAnswer = "Yes" } label: {
                FormCheckbox(title: "Yes", isSelected: allergiesAnswer == "Yes")
            }

            Button { allergiesAnswer = "Not sure" } label: {
                FormCheckbox(title: "Not sure", isSelected: allergiesAnswer == "Not sure")
            }
        }
        .buttonStyle(.plain)
    }

    private var questionSix: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("6)   If yes, which ones")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            FormTextBox(text: $allergiesDetails)        }
    }

    private var questionSeven: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7)   Have you noticed any spots, rashes, or\nlesions recently?")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))

            Button { lesionsAnswer = "Yes" } label: {
                FormCheckbox(title: "Yes", isSelected: lesionsAnswer == "Yes")
            }

            Button { lesionsAnswer = "No" } label: {
                FormCheckbox(title: "No", isSelected: lesionsAnswer == "No")
            }
        }
        .buttonStyle(.plain)
    }
}
