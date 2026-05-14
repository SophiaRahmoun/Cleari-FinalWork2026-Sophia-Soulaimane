//
//  HelpSupportRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

import SwiftUI

struct HelpSupportRow: View {
    let item: HelpSupportItem
    let isOpen: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 24) {
                    Image(systemName: item.iconName)
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(Color(hex: "1A1018"))
                        .frame(width: 34)

                    Text(item.title)
                        .font(AppFont.gillSwiftUI(.regular, size: 22))
                        .foregroundColor(Color(hex: "1A1018"))
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isOpen ? "chevron.down" : "chevron.right")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Color(hex: "1A1018"))
                }

                if isOpen {
                    Text(item.description)
                        .font(AppFont.gillSwiftUI(.regular, size: 15))
                        .foregroundColor(Color(hex: "1A1018").opacity(0.7))
                        .lineSpacing(4)
                        .padding(.leading, 58)
                        .padding(.trailing, 30)
                }

                Divider()
                    .background(Color(hex: "1A1018").opacity(0.15))
                    .padding(.leading, 58)
            }
        }
        .buttonStyle(.plain)
    }
}
