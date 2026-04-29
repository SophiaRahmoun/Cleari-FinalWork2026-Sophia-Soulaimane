//
//  FindDermatologistView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct FindDermatologistView: View {
    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
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
                        DermatologistFilterLabel(title: "On my location")
                    }

                    Text("Top matches for you")
                        .font(AppFont.gillSwiftUI(.regular, size: 18))
                        .foregroundColor(Color(hex: "1A1018"))

                    VStack(spacing: 20) {
                        DermatologistCard(
                            imageName: "ProfileSample",
                            name: "Dr. Sarah Ben Ali",
                            description: "Lorem ipsum",
                            city: "Brussels",
                            rating: "4.9"
                        )

                        DermatologistCard(
                            imageName: "ProfileSample",
                            name: "Dr. Halioui Saïd",
                            description: "Lorem ipsum",
                            city: "Brussels",
                            rating: "4.9"
                        )

                        DermatologistCard(
                            imageName: "ProfileSample",
                            name: "Dr. Stefan Tilburgs",
                            description: "Lorem ipsum",
                            city: "Brussels",
                            rating: "4.9"
                        )
                    }
                }
                .padding(.horizontal, 34)

                Spacer()

                ScanBottomBar()
            }
        }
    }
}
