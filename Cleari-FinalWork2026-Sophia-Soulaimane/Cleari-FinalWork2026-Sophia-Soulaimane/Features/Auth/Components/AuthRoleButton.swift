//
//  AuthRoleButton.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthRoleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            TypographyLabel(
                text: title,
                style: .button,
                color: .black
            )
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundColor(.black)
                        .offset(y: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AuthRoleButton(
        title: "Dermatologist",
        isSelected: true
    ) {
        print("role tapped")
    }
}
