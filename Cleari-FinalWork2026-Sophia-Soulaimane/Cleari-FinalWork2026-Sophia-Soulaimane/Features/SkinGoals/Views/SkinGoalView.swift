//
//  SkinGoalView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 12/05/2026.
//

import SwiftUI

struct SkinGoalView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var aboutUser = ""
    @State private var selectedSkinGoals: Set<String> = [
        "Hydrated skin",
        "Reduce acne",
        "Smooth texture",
        "Reduce hyperpigmentation"
    ]

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 34) {
                    header
                    aboutSection
                    introText
                    hydrationSection
                    skinConcernsSection
                    saveButton
                }
                .padding(.horizontal, 34)
                .padding(.top, 70)
                .padding(.bottom, 45)
            }
        }
    }
}

extension SkinGoalView {
    private var header: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(.white)
                }

                Spacer()
            }

            Text("Skin goals")
                .font(AppFont.gillSwiftUI(.bold, size: 40))
                .foregroundColor(.black)
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Write something about you")
                .font(AppFont.gillSwiftUI(.bold, size: 28))
                .foregroundColor(Color(hex: "1A1018"))

            FormTextBox(text: $aboutUser)
                .frame(height: 170)
        }
    }

    private var introText: some View {
        Text("Select what you want to improve. This\nhelps people understand you")
            .font(AppFont.gillSwiftUI(.regular, size: 24))
            .foregroundColor(Color(hex: "1A1018"))
            .lineSpacing(4)
    }

    private var hydrationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hydration")
                .font(AppFont.gillSwiftUI(.bold, size: 30))
                .foregroundColor(.black)

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    goalButton("Hydrated skin")
                    goalButton("Reduce dryness")
                }

                HStack(spacing: 8) {
                    goalButton("Improve skin barrier")
                    goalButton("Sensitive skin")
                }
            }
        }
    }

    private var skinConcernsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skin concerns")
                .font(AppFont.gillSwiftUI(.bold, size: 30))
                .foregroundColor(.black)

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    goalButton("Reduce acne")
                    goalButton("Calm irritation")
                }

                HStack(spacing: 8) {
                    goalButton("Even skin tone")
                    goalButton("Smooth texture")
                }

                HStack(spacing: 8) {
                    goalButton("Reduce fine lines")
                    goalButton("Improve skin barrier")
                }

                HStack(spacing: 8) {
                    goalButton("Minimize pores")
                    goalButton("Reduce hyperpigmentation")
                }

                HStack(spacing: 8) {
                    goalButton("Reduce under-eyes circles")
                }
            }
        }
    }

    private var saveButton: some View {
        PrimaryButton(title: "Save skin goals") {
            print("About user:", aboutUser)
            print("Selected skin goals:", selectedSkinGoals)
        }
        .padding(.top, 45)
    }

    private func goalButton(_ title: String) -> some View {
        Button {
            if selectedSkinGoals.contains(title) {
                selectedSkinGoals.remove(title)
            } else {
                selectedSkinGoals.insert(title)
            }
        } label: {
            FormChoicePill(
                title: title,
                isSelected: selectedSkinGoals.contains(title)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SkinGoalView()
}
