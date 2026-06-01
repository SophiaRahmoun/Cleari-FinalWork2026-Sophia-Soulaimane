//
//  FeedTopBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct FeedTopBar: View {
    var onFakeTrendsTapped: (() -> Void)? = nil
    var onProfileTapped: (() -> Void)? = nil

    @State private var activeTab: Tab = .explore

    enum Tab { case explore, fakeTrends }

    private let dark = Color(hex: "1A1018")
    private let accent = Color(hex: "F2E53E") // yellow highlight from Figma

    var body: some View {
        VStack(spacing: 14) {
            // ── Top row: logo + profile icon ──
            HStack(alignment: .center) {
                Spacer()

                Text("cleari")
                    .font(AppFont.gillSwiftUI(.regular, size: 28))
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

            // ── Tab row: explore | fake trends ──
            HStack(spacing: 0) {
                Spacer()

                // Explore tab
                Button {
                    activeTab = .explore
                } label: {
                    Text("explore")
                        .font(AppFont.gillSwiftUI(.regular, size: 16))
                        .foregroundColor(dark)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            activeTab == .explore
                                ? accent
                                : Color.clear
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Spacer()

                // Fake trends tab
                Button {
                    activeTab = .fakeTrends
                    onFakeTrendsTapped?()
                } label: {
                    Text("fake trends")
                        .font(AppFont.gillSwiftUI(.regular, size: 16))
                        .foregroundColor(dark)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            activeTab == .fakeTrends
                                ? accent
                                : Color.clear
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
            .ignoresSafeArea()
        FeedTopBar()
    }
}
