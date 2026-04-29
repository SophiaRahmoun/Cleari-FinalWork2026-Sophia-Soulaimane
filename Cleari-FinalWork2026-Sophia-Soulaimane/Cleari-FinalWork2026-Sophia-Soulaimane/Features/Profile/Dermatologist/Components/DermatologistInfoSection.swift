//
//  DermatologistInfoSection.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct DermatologistInfoSection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFont.gillSwiftUI(.bold, size: 28))
                .foregroundColor(Color(hex: "1A1018"))

            Text(content)
                .font(AppFont.gillSwiftUI(.regular, size: 16))
                .foregroundColor(Color(hex: "1A1018"))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
