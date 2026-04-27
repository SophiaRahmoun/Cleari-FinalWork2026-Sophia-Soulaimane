//
//  AuthRegisterInput.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthRegisterInput: View {
    let label: String
    @Binding var text: String
    let maxLength: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#E6DED6")) // beige
                .shadow(color: .black.opacity(0.1), radius: 6, y: 4)

            HStack {
                // Label
                TypographyLabel(
                    text: label,
                    style: .button,
                    color: .black
                )

                Spacer()

                // Counter
                TypographyLabel(
                    text: "\(text.count) / \(maxLength)",
                    style: .button,
                    color: .black
                )
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 65)
    }
}

#Preview {
    ZStack {
        AuthBackground()

        AuthRegisterInput(
            label: "Voornaam",
            text: .constant(""),
            maxLength: 50
        )
        .padding(.horizontal, 32)
    }
}
