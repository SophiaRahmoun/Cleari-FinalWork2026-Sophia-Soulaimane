//
//  LogoutConfirmationSheet.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/06/2026.
//

import SwiftUI

struct LogoutConfirmationView: View {
    var onLogoutTapped: () -> Void
    var onCancelTapped: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            Text("Log out?")
                .font(AppFont.gillSwiftUI(.bold, size: 26))
                .foregroundColor(Color(hex: "1A1018"))

            Text("Are you sure you want to log out?")
                .font(AppFont.gillSwiftUI(.regular, size: 17))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)

            PrimaryButton(title: "yes") {
                onLogoutTapped()
            }

            Button {
                onCancelTapped()
            } label: {
                Text("no")
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(Color(hex: "1A1018"))
            }
        }
        .padding(26)
        .background(Color("AccentColor"))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 8)
    }
}
