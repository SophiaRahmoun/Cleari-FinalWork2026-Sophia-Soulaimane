//
//  AppointmentEmptyMessage.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import SwiftUI

struct AppointmentEmptyMessage: View {
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TypographyLabel(
                text: title,
                style: .body,
                color: .black
            )

            TypographyLabel(
                text: message,
                style: .caption,
                color: .black.opacity(0.65)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
