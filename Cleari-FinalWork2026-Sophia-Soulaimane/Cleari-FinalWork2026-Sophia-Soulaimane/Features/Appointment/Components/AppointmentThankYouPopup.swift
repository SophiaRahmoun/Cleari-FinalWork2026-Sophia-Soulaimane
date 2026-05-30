//
//  AppointmentThankYouPopup.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct AppointmentThankYouPopup: View {
    let dermatologistName: String
    let onOK: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.05)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                TypographyLabel(
                    text: "Thank you!",
                    style: .h2,
                    color: .black,
                    alignment: .center
                )

                TypographyLabel(
                    text: "We have made the request to\n\(dermatologistName). Under ‘Appointments’\nin Profile, you will find\nout if the appointment has been\napproved or not.",
                    style: .body,
                    color: .black,
                    alignment: .center
                )

                Button {
                    onOK()
                } label: {
                    Text("OK")
                        .font(AppFont.gillSwiftUI(.bold, size: 14))
                        .foregroundColor(.black)
                        .frame(width: 120, height: 34)
                        .background(Color.black.opacity(0.15))
                        .cornerRadius(10)
                }
            }
            .padding(28)
            .frame(maxWidth: 260)
            .background(Color.white.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 1.5)
            )
            .cornerRadius(16)
        }
    }
}
