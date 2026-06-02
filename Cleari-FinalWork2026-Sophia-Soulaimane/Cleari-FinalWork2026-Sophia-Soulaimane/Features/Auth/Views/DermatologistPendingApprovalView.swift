//
//  DermatologistPendingApprovalView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 20/05/2026.
//

import SwiftUI

struct DermatologistPendingApprovalView: View {
    var onLogout: () -> Void = {}
    private let textColor = Color(hex: "1E141D")
    var body: some View {

        ZStack {
            RadialGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                Image(systemName: "clock.badge.checkmark")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundColor(textColor)
                TypographyLabel(
                    text: "Verification pending",
                    style: .h1Italic,
                    color: textColor,
                    alignment: .center
                )

                TypographyLabel(
                    text: "Thank you for registering as a dermatologist. Your certificate and profile are currently being reviewed by the Cleari team.",
                    style: .body,
                    color: textColor,
                    alignment: .center
                )
                .padding(.horizontal, 28)
                VStack(spacing: 14) {
                    PendingStepRow(
                        icon: "doc.text.magnifyingglass",
                        title: "Certificate review",
                        subtitle: "We check your professional information."
                    )

                    PendingStepRow(
                        icon: "checkmark.seal",
                        title: "Admin approval",
                        subtitle: "Your account will be activated after approval."
                    )

                    PendingStepRow(
                        icon: "person.crop.circle.badge.checkmark",
                        title: "Dermatologist access",
                        subtitle: "Once approved, you can access dermatologist features."
                    )
                }
                .padding(.top, 10)
                PrimaryButton(title: "LOG OUT") {
                    onLogout()
                }
                .padding(.horizontal, 60)
                .padding(.top, 20)
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}

struct PendingStepRow: View {
    let icon: String
    let title: String
    let subtitle: String
    private let textColor = Color(hex: "1E141D")
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(textColor)
                .frame(width: 34)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(textColor)
                Text(subtitle)
                    .font(AppFont.gillSwiftUI(.regular, size: 13))
                    .foregroundColor(textColor.opacity(0.75))
            }

            Spacer()
        }
        .padding(16)
        .background(.white.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 22))

    }

}
