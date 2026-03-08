//
//  LinearGradientBackground.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 08/03/2026.
//


import SwiftUI
import UIKit

struct LinearGradientBackground: UIViewRepresentable {
    let startHex: String
    let endHex: String

    func makeUIView(context: Context) -> LinearGradientView {
        LinearGradientView(startHex: startHex, endHex: endHex)
    }

    func updateUIView(_ uiView: LinearGradientView, context: Context) {
        uiView.colors = [
            UIColor(hex: startHex),
            UIColor(hex: endHex)
        ]
    }
}