//
//  AddDebunkInputField.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct AddDebunkInputField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFont.gillSwiftUI(.regular, size: 15))
            .foregroundColor(Color(hex: "1A1018"))
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(Color("AccentColor"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 5)
    }
}
