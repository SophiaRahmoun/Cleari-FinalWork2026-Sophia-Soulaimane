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
    var activeTab: FeedTab = .explore

    enum FeedTab { case explore, fakeTrends }

    private let dark = Color(hex: "1A1018")

    var body: some View {
        VStack(spacing: 24) {
            // ── Top row: logo perfectly centered + profile icon overlaid right ──
            ZStack {
                Image("Cleari_Header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .frame(maxWidth: .infinity)

                HStack {
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
            }
            .padding(.top, 16)

            // ── Tab row: explore | fake trends ──
            HStack(spacing: 100) {
                Button {
                    onExploreTapped?()
                } label: {
                    TypographyLabel(text: "explore", style: .button, color: .white)
                        .underline(activeTab == .explore)
                }
                .buttonStyle(.plain)

                Button {
                    onFakeTrendsTapped?()
                } label: {
                    TypographyLabel(text: "fake trends", style: .button, color: .white)
                        .underline(activeTab == .fakeTrends)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}
