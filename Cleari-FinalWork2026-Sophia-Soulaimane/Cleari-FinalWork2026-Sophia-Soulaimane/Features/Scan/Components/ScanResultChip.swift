//
//  ScanResultChip.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ScanResultChip: View {
    let title: String
    let value: String

    var body: some View {
        Text("\(title): \(value)")
            .font(.subheadline)
            .foregroundColor(Color("AccentColor"))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .overlay(
                Capsule()
                    .stroke(Color("AccentColor"), lineWidth: 1)
            )
    }
}
