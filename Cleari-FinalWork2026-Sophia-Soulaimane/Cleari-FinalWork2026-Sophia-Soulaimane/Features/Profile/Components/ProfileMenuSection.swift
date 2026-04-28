//
//  ProfileMenuSection.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ProfileMenuSection: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppFont.gillSwiftUI(.bold, size: 28))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 22)
    }
}
