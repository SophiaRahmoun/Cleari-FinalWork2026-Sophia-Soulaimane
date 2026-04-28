//
//  ProfileMenuRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ProfileMenuRow: View {
    let title: String
    var isDestructive: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(AppFont.gillSwiftUI(.regular, size: 18))
                .foregroundColor(isDestructive ? Color.pink : .white)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, 10)
    }
}
