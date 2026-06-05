//
//  AuthBottomLink.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthBottomLink: View {
    let text: String
    let linkText: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 3) {
                TypographyLabel(
                    text: text,
                    style: .body,
                    color: .black
                )

                TypographyLabel(
                    text: linkText,
                    style: .button,
                    color: .black
                )
            }
        }
    }
}

#Preview {
    AuthBottomLink(
        text: "already have an account?",
        linkText: "Login"
    )
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 32)
    .padding(.top, 80)
}
