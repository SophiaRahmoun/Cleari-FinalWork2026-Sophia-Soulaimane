//
//  DermatologistProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct DermatologistProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            DermatologistProfileBackground(imageName: "authBackground")

            VStack(alignment: .leading, spacing: 22) {
                header

                Spacer()

                labels

                bioSection

                expertiseSection

                PrimaryButton(title: "take appointment") {
                    print("Take appointment tapped")
                }
                .padding(.horizontal, 70)
            }
            .padding(.horizontal, 34)
            .padding(.top, 55)
            .padding(.bottom, 45)
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(.white)
            }

            VStack(spacing: 8) {
                Text("Dr Sarah Ben Ali")
                    .font(AppFont.gillSwiftUI(.bold, size: 30))
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    Text("Dermatologist")
                    Text("•")
                    Text("10 years experience")
                }
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var labels: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                DarkLabel(title: "Brussels")
                DarkLabel(title: "Female")
                DarkLabel(title: "Online In-person")
            }

            HStack(spacing: 10) {
                DarkLabel(title: "Acne . Rosacea")
                DarkLabel(title: "Hyperpigmentation")
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            DermatologistSectionTitle(title: "Bio")

            Text("Dr. Laurent specializes in skin inflammation, acne treatment, and sensitive skin conditions. She helps patients understand their skin and guides them toward safe, effective routines.")
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(Color(hex: "1A1018"))
                .lineSpacing(4)
        }
    }

    private var expertiseSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            DermatologistSectionTitle(title: "Expertise")

            DermatologistExpertiseRow(title: "Acne & breakouts")
            DermatologistExpertiseRow(title: "Sensitive skin")
            DermatologistExpertiseRow(title: "Hyperpigmentation")
            DermatologistExpertiseRow(title: "Rosacea")
            DermatologistExpertiseRow(title: "Anti-aging care")
        }
    }
}

#Preview {
    DermatologistProfileView()
}

