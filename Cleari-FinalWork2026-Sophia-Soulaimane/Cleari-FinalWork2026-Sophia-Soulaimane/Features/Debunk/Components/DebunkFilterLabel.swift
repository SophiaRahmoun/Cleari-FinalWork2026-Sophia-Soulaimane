//
//  DebunkFilterLabel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct DebunkFilterLabel: View {
    let title: String
    var isSelected: Bool = false

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.regular, size: 18))
            .foregroundColor(isSelected ? .white : Color(hex: "1A1018"))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "1A1018") : Color(hex: "F4D4D7"))
            )
            .overlay(
                Capsule()
                    .stroke(Color(hex: "1A1018"), lineWidth: 2)
            )
    }
}
