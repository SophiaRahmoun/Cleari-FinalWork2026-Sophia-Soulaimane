//
//  TextSpan.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 08/03/2026.
//

import SwiftUI

enum TextSpan {
    
    static func body(_ text: String, color: Color = .primary) -> Text {
        Text(text)
            .font(AppFont.gillSwiftUI(.regular, size: 16))
            .foregroundColor(color)
    }
    
    static func bodyItalic(_ text: String, color: Color = .primary) -> Text {
        Text(text)
            .font(AppFont.gillSwiftUI(.italic, size: 16))
            .foregroundColor(color)
    }
    
    static func h1(_ text: String, color: Color = .primary) -> Text {
        Text(text)
            .font(AppFont.corporateSwiftUI(.medium, size: 34))
            .foregroundColor(color)
    }
    
    static func h1Italic(_ text: String, color: Color = .primary) -> Text {
        Text(text)
            .font(AppFont.corporateSwiftUI(.regular, size: 34))
            .foregroundColor(color)
    }
    
    static func button(_ text: String, color: Color = .white) -> Text {
        Text(text)
            .font(AppFont.gillSwiftUI(.bold, size: 18))
            .foregroundColor(color)
    }
    
    static func buttonItalic(_ text: String, color: Color = .white) -> Text {
        Text(text)
            .font(AppFont.gillSwiftUI(.boldItalic, size: 18))
            .foregroundColor(color)
    }
}
