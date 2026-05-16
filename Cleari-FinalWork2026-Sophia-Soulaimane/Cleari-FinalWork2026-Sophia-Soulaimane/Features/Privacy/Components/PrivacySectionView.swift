//
//  PrivacySectionView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 16/05/2026.
//

import SwiftUI

struct PrivacySectionView: View {
    let section: PrivacySection

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(section.title)
                .font(AppFont.gillSwiftUI(.bold, size: 22))
                .foregroundColor(Color(hex: "1A1018"))

            Text(section.text)
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(Color(hex: "1A1018").opacity(0.85))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.35))
        .cornerRadius(24)
    }
}
