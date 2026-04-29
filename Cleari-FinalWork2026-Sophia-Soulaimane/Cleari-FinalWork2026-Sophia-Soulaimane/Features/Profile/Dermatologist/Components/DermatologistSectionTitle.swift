//
//  DermatologistSectionTitle.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct DermatologistSectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.bold, size: 28))
            .foregroundColor(Color(hex: "1A1018"))
    }
}
