//
//  AddDebunkStatusButton.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct AddDebunkStatusButton: View {
    let icon: String
    let title: String
    let iconColor: Color
    var isSelected: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(iconColor)

                Text(title)
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(Color(hex: "1A1018"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 38)
            .background(Color("AccentColor"))
            .overlay(
                Capsule()
                    .stroke(Color(hex: "1A1018"), lineWidth: 1.2)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
