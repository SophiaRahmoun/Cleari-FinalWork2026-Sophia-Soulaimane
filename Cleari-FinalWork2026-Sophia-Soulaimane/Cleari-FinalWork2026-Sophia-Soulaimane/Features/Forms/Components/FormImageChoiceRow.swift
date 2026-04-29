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
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 46)
                .foregroundColor(Color("AccentColor"))

            Text(title)
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
