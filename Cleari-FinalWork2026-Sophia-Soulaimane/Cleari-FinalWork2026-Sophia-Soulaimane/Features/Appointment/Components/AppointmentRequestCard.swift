//
//  AppointmentRequestCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct AppointmentRequestCard: View {
    let userName: String
    let appointmentDate: String
    let timeAgo: String
    let profileImageUrl: String

    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(spacing: 18) {

            HStack(alignment: .center, spacing: 14) {

                AsyncImage(url: URL(string: profileImageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 58, height: 58)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {

                    TypographyLabel(
                        text: userName,
                        style: .body,
                        color: .black
                    )

                    TypographyLabel(
                        text: appointmentDate,
                        style: .caption,
                        color: .black.opacity(0.75)
                    )
                }

                Spacer()

                TypographyLabel(
                    text: timeAgo,
                    style: .caption,
                    color: .black.opacity(0.75)
                )
            }

            HStack(spacing: 14) {

                AppointmentActionButton(
                    title: "decline",
                    backgroundColor: Color(hex: "C66F8C")
                ) {
                    onDecline()
                }

                AppointmentActionButton(
                    title: "accept",
                    backgroundColor: Color(hex: "3A0616")
                ) {
                    onAccept()
                }
            }
        }
        .padding(.vertical, 10)
    }
}
