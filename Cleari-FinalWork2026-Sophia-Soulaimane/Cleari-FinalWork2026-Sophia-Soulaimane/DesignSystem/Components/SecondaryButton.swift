//
//  SecondaryButton.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.gillSwiftUI(.bold, size: 18))
                .foregroundColor(Color("AccentColor"))
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "1A1018"))
                .clipShape(Capsule())
        }
    }
}
