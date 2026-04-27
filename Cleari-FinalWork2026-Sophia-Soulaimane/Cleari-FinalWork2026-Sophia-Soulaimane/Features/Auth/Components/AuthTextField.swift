//
//  AuthTextField.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            inputField

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)

            TypographyLabel(
                text: label,
                style: .button,
                color: .white
            )
        }
        .overlay(alignment: .topLeading) {
            if text.isEmpty {
                TypographyLabel(
                    text: placeholder,
                    style: .button,
                    color: .black.opacity(0.6)
                )
                .offset(y: -2)
                .allowsHitTesting(false)
            }
        }
    }

    private var inputField: some View {
        Group {
            if isSecure {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
        }
        .font(AppFont.gillSwiftUI(.bold, size: 16))
        .foregroundColor(.black)
    }
}

#Preview {
    ZStack {
        AuthBackground()

        VStack(spacing: 32) {
            AuthTextField(
                label: "Your e-mail address",
                placeholder: "example@gmail.com",
                text: .constant("")
            )

            AuthTextField(
                label: "Your password",
                placeholder: "••••••••••••••••",
                text: .constant(""),
                isSecure: true
            )
        }
        .padding(.horizontal, 32)
    }
}
