    //
    //  FindDermatologistView.swift
    //  Cleari-FinalWork2026-Sophia-Soulaimane
    //
    //  Created by Soulaimane Saadi on 29/04/2026.
    //

import SwiftUI

struct FindDermatologistView: View {
    private let dermatologists = Dermatologist.mockDermatologists

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 26) {
                    Text("Recommended\ndermatologist")
                        .font(AppFont.gillSwiftUI(.regular, size: 42))
                        .foregroundColor(Color(hex: "1A1018"))
                        .lineSpacing(4)

                    HStack(spacing: 8) {
                        DermatologistFilterLabel(title: "Any", isSelected: true)
                        DermatologistFilterLabel(title: "Male")
                        DermatologistFilterLabel(title: "Female")
                        DermatologistFilterLabel(title: "Location")
                    }

                    Text("Top matches for you")
                        .font(AppFont.gillSwiftUI(.regular, size: 18))
                        .foregroundColor(Color(hex: "1A1018"))

                    VStack(spacing: 20) {
                        ForEach(dermatologists) { dermatologist in
                            DermatologistCard(
                                imageName: dermatologist.imageName,
                                name: dermatologist.name,
                                description: dermatologist.description,
                                city: dermatologist.city,
                                rating: String(dermatologist.rating)
                            )
                        }
                    }
                }
                .padding(.horizontal, 34)

                Spacer()

                ScanBottomBar()
            }
        }
    }
}
