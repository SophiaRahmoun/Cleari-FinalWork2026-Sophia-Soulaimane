//
//  FeedTopBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct FeedTopBar: View {
    var onExploreTapped: (() -> Void)? = nil
    var onFakeTrendsTapped: (() -> Void)? = nil
    var onProfileTapped: (() -> Void)? = nil

    private let dark = Color(hex: "1A1018")

    var body: some View {
        VStack(spacing: 14) {
            // ── Top row: logo + profile icon ──
            HStack {
                Spacer()

                Text("cleari")
                    .font(AppFont.gillSwiftUI(.regular, size: 30))
                    .foregroundColor(dark)

                Spacer()

                Button {
                    onProfileTapped?()
                } label: {
                    Image(systemName: "person")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(dark)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            // ── Tab row: explore (underlined) | fake trends ──
            HStack(spacing: 0) {
                Spacer()

                Button {
                    onExploreTapped?()
                } label: {
                    Text("explore")
                        .font(AppFont.gillSwiftUI(.regular, size: 16))
                        .foregroundColor(dark)
                        .underline()
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    onFakeTrendsTapped?()
                } label: {
                    Text("fake trends")
                        .font(AppFont.gillSwiftUI(.regular, size: 16))
                        .foregroundColor(dark)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(.top, 10)
    }
}
