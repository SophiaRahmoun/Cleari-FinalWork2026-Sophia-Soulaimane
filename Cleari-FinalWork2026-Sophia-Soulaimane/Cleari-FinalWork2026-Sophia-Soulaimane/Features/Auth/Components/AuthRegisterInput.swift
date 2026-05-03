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
    var isSecure: Bool = false
    
    var body: some View {
        Group {
                   if isSecure {
                       SecureField(label, text: $text)
                   } else {
                       TextField(label, text: $text)
                           .textInputAutocapitalization(.never)
                           .autocorrectionDisabled()
                   }
               }

               .font(AppFont.gillSwiftUI(.regular, size: 18))
               .foregroundColor(.black)
               .padding(.horizontal, 20)
               .frame(height: 65)
               .background(
                   RoundedRectangle(cornerRadius: 20)
                       .fill(Color(hex: "E6DED6"))
                       .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
               )
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
