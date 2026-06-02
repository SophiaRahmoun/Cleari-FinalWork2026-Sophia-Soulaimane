//
//  EditProfileRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

import SwiftUI

struct EditProfileRow: View {
    let title: String
    let value: String
    var showChevron: Bool = false
    var isDisabled: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(title)
                    .font(AppFont.gillSwiftUI(.regular, size: 18))
                    .foregroundColor(Color(hex: "1A1018"))

                Spacer()

                Text(value)
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(Color(hex: "1A1018").opacity(0.45))
                    .multilineTextAlignment(.trailing)

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color(hex: "1A1018"))
                        .padding(.leading, 8)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}
