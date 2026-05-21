//
//  AddDebunkMessageCardCompact.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/05/2026.
//

import SwiftUI

struct AddDebunkMessageCardCompact: View {
    @Binding var message: String

    let imageName: String
    let name: String
    let role: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("AccentColor"))
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    AvatarView(imageName: imageName, size: 32)

                    VStack(alignment: .leading, spacing: 1) {
                        Text(name)
                            .font(AppFont.gillSwiftUI(.bold, size: 14))

                        Text(role)
                            .font(AppFont.gillSwiftUI(.regular, size: 11))
                    }
                }

                Divider().opacity(0.3)

                TextEditor(text: $message)
                    .font(AppFont.gillSwiftUI(.regular, size: 13))
                    .frame(height: 50)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .padding(12)
        }
        .frame(height: 110)
    }
}
