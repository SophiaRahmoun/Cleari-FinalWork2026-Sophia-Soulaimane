//
//  DermatologistExpertiseRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct DermatologistExpertiseRow: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.regular, size: 16))
            .foregroundColor(Color(hex: "1A1018"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
