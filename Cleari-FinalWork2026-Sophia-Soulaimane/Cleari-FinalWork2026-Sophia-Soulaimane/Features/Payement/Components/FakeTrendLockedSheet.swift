//
//  FakeTrendLockedSheet.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 25/05/2026.
//

import SwiftUI

struct FakeTrendLockedSheet: View {
    var onUnlockTapped: () -> Void
    var onNotNowTapped: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            Text("Unlock fake trends")
                .font(AppFont.gillSwiftUI(.bold, size: 26))
                .foregroundColor(Color(hex: "1A1018"))

            Text("Subscribe to access certified dermatologist debunks and premium skincare advice.")
                .font(AppFont.gillSwiftUI(.regular, size: 17))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)

            PrimaryButton(title: "unlock premium") {
                onUnlockTapped()
            }

            Button {
                onNotNowTapped()
            } label: {
                Text("not now")
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
