    //
//  FormTextBox.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct FormTextBox: View {
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.35))
                .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 8)

            TextEditor(text: $text)
                .padding(12)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(Color(hex: "1A1018"))

            if text.isEmpty {
                Text("Type here...")
                    .foregroundColor(.black.opacity(0.4))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
            }
        }
        .frame(height: 120)
    }
}
