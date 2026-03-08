//
//  TypographyLabel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 08/03/2026.
//
import SwiftUI

struct TypographyLabel: View {
    
    enum Style {
        case h1
        case h1Italic
        case h2
        case h2Italic
        case body
        case bodyItalic
        case caption
        case captionItalic
        case button
        case buttonItalic
    }
    
    let text: String
    let style: Style
    var color: Color = .primary
    var alignment: TextAlignment = .leading
    
    var body: some View {
        Text(text)
            .font(font(for: style))
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
    
    private func font(for style: Style) -> Font {
        switch style {
        case .h1:
            return AppFont.corporateSwiftUI(.medium, size: 34)
        case .h1Italic:
            return AppFont.corporateSwiftUI(.regular, size: 34)
        case .h2:
            return AppFont.corporateSwiftUI(.regular, size: 26)
        case .h2Italic:
            return AppFont.corporateSwiftUI(.regular, size: 26)
        case .body:
            return AppFont.gillSwiftUI(.regular, size: 16)
        case .bodyItalic:
            return AppFont.gillSwiftUI(.italic, size: 16)
        case .caption:
            return AppFont.gillSwiftUI(.light, size: 12)
        case .captionItalic:
            return AppFont.gillSwiftUI(.italic, size: 12)
        case .button:
            return AppFont.gillSwiftUI(.bold, size: 18)
        case .buttonItalic:
            return AppFont.gillSwiftUI(.boldItalic, size: 18)
        }
    }
}
