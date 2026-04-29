//
//  FormCheckbox.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct FormCheckbox: View {
    let title: String
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("AccentColor"), lineWidth: 1.4)
                .frame(width: 14, height: 14)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color("AccentColor") : Color.clear)
                )

            Text(title)
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()
        }
    }
}
