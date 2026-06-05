//
//  AddDebunkSectionTitle.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/05/2026.
//

import SwiftUI

struct AddDebunkSectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.regular, size: 20))
            .foregroundColor(Color(hex: "1A1018"))
    }
}
