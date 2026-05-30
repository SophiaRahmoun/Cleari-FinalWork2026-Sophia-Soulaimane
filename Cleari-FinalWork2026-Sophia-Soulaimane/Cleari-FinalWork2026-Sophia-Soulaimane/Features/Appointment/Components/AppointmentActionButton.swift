//
//  AppointmentActionButton.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct AppointmentActionButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            TypographyLabel(
                text: title,
                style: .button,
                color: .white,
                alignment: .center
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
