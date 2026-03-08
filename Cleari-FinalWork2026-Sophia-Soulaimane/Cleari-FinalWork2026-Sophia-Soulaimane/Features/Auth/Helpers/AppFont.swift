//
//  AppFont.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 08/03/2026.
//

import UIKit
import SwiftUI

enum AppFont {

    enum CorporateACondensed: String {
        case regular = "CorporateACondPro-Regular"
        case medium = "CorporateAPro-Medium"
    }

    enum GillSans: String {
        case regular = "GillSans"
        case bold = "GillSans-Bold"
        case medium = "GillSans-Medium"
        case light = "GillSans-Light"
        case italic = "GillSans-Italic"
        case boldItalic = "GillSans-BoldItalic"
    }

    static func corporate(_ style: CorporateACondensed, size: CGFloat) -> UIFont {
        UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size)
    }

    static func gill(_ style: GillSans, size: CGFloat) -> UIFont {
        UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size)
    }

    static func corporateSwiftUI(_ style: CorporateACondensed, size: CGFloat) -> Font {
        Font.custom(style.rawValue, size: size)
    }

    static func gillSwiftUI(_ style: GillSans, size: CGFloat) -> Font {
        Font.custom(style.rawValue, size: size)
    }
}
