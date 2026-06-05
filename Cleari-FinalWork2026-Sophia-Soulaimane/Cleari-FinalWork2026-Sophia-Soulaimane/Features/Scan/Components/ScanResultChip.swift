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

    private let dark = Color(hex: "1E141D")

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppFont.gillSwiftUI(.bold, size: 15))
                .foregroundColor(chipColor)
            Text(title)
                .font(AppFont.gillSwiftUI(.regular, size: 12))
                .foregroundColor(dark.opacity(0.55))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(chipColor.opacity(0.10))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(chipColor.opacity(0.35), lineWidth: 1)
                )
        )
    }

    /// Colour by level label coming from the backend
    private var chipColor: Color {
        switch value.lowercased() {
        case "good", "low":      return Color(hex: "7CC47A")   // soft green
        case "moderate":         return Color(hex: "E8A96A")   // warm amber
        case "elevated", "high": return Color(hex: "C66F8C")   // Cleari pink
        case "oily":             return Color(hex: "E8A96A")
        case "dry":              return Color(hex: "87BCDE")   // soft blue
        case "combination":      return Color(hex: "E8A96A")
        case "normal":           return Color(hex: "7CC47A")
        default:                 return Color(hex: "1E141D").opacity(0.6)
        }
    }
}
