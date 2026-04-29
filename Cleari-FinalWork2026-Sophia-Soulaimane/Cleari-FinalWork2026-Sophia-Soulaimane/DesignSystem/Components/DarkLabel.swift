//
//  DarkLabel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct DarkLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.regular, size: 16))
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(Color(hex: "1A1018"))
            )
            .overlay(
                Capsule()
                    .stroke(Color("AccentColor"), lineWidth: 1)
            )
    }
}
