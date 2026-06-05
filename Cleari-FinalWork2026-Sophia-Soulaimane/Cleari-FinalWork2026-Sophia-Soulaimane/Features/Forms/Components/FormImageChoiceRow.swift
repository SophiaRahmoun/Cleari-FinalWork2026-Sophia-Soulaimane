//
//  FormImageChoiceRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct FormImageChoiceRow: View {
    let imageName: String
    let title: String
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(isSelected ? Color("AccentColor") : Color(hex: "1A1018"))

            Text(title)
                .font(AppFont.gillSwiftUI(.regular, size: 12))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}
