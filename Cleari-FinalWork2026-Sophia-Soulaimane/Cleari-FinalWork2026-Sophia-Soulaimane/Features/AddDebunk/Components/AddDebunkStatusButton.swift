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
    var isSelected: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))

                Text(title)
                    .font(AppFont.gillSwiftUI(.regular, size: 18))
            }
            .foregroundColor(Color(hex: "1A1018"))
            .frame(height: 46)
            .padding(.horizontal, 20)
            .background(isSelected ? Color(hex: "F4D4D7") : Color.white.opacity(0.75))
            .overlay(
                Capsule()
                    .stroke(Color(hex: "1A1018"), lineWidth: 1.5)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
