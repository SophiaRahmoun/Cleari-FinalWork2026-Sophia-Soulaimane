//
//  DermatologistProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct DermatologistProfileView: View {
    let dermatologist: Dermatologist
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

                PrimaryButton(title: "schedule") {
                    print("schedule appointment tapped")
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
                Text(dermatologist.name)
                    .font(AppFont.gillSwiftUI(.bold, size: 30))
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    Text("Dermatologist")
                    Text("•")
                    Text(dermatologist.experience)
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
                DarkLabel(title: dermatologist.city)
                DarkLabel(title: dermatologist.gender)
                DarkLabel(title: dermatologist.availability)
            }

            HStack(spacing: 10) {
                DarkLabel(title: dermatologist.speciality)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            DermatologistSectionTitle(title: "Bio")

            Text(dermatologist.description)
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(Color(hex: "1A1018"))
                .lineSpacing(4)
        }
    }

    private var expertiseSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            DermatologistSectionTitle(title: "Expertise")

            DermatologistExpertiseRow(title: dermatologist.speciality)
            DermatologistExpertiseRow(title: "Sensitive skin")
            DermatologistExpertiseRow(title: "Skin routine advice")
        }
    }
}

#Preview {
    DermatologistProfileView(
        dermatologist: Dermatologist.mockDermatologists[0]
    )
}
