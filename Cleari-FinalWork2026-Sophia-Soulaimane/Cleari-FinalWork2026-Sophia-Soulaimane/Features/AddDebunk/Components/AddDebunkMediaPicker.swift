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
                .font(.system(size: 34))
                .foregroundColor(Color("AccentColor"))
                .frame(maxWidth: .infinity)
                .frame(height: 74)
                .background(Color("AccentColor"))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.14), radius: 9, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}
