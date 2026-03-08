//
//  Untitled.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 08/03/2026.
//

import SwiftUI
import UIKit

struct RadialGradientBackground: UIViewRepresentable {
    let startHex: String
    let endHex: String

    func makeUIView(context: Context) -> RadialGradientView {
        RadialGradientView(startHex: startHex, endHex: endHex)
    }

    func updateUIView(_ uiView: RadialGradientView, context: Context) {
        uiView.colors = [
            UIColor(hex: startHex),
            UIColor(hex: endHex)
        ]
    }
}
