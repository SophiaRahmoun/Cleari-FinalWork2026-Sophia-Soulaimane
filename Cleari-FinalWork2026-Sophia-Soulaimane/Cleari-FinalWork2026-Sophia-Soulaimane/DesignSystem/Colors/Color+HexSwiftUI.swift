//
//  Color+HexSwiftUI.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 08/03/2026.
//

import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let uiColor = UIColor(hex: hex, alpha: alpha)
        self.init(uiColor)
    }
}
