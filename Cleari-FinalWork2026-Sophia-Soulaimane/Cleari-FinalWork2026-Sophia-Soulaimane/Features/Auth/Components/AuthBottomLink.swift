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

    var body: some View {
        HStack(spacing: 4) {
            TypographyLabel(
                text: text,
                style: .caption,
                color: .black
            )

            TypographyLabel(
                text: linkText,
                style: .caption,
                color: .black
            )
        }
    }
}

#Preview {
    AuthBottomLink(
        text: "already have an account?",
        linkText: "Login"
    )
}
