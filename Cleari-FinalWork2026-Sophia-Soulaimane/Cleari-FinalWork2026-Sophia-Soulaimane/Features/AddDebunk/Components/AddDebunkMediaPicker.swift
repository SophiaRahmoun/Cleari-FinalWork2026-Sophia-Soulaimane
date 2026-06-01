//
//  AddDebunkMediaPicker.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct AddDebunkMediaPicker: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "photo")
                .font(.system(size: 30, weight: .regular))
                .foregroundColor(Color(hex: "C66F8C"))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Color("AccentColor"))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}
