//
//  AddDebunkButton.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct AddDebunkButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("add debunk")
                .font(AppFont.gillSwiftUI(.bold, size: 16))
                .foregroundColor(Color("AccentColor"))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color(hex: "1A1018"))
                .clipShape(Capsule())
        }
    }
}
