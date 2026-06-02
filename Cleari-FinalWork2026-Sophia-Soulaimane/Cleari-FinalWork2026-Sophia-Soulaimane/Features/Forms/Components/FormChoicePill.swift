//
//  FormChoicePill.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct FormChoicePill: View {
    let title: String
    var isSelected: Bool = false

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.regular, size: 13))
            .foregroundColor(isSelected ? Color("AccentColor") : Color(hex: "1A1018"))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "1A1018") : Color.white.opacity(0.55))
            )
            .overlay(
                Capsule()
                    .stroke(Color(hex: "1A1018"), lineWidth: 1.2)
            )
    }
}
