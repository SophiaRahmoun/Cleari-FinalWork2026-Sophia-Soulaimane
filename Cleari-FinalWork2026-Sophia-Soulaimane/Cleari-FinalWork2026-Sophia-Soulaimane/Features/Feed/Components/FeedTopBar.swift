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
            HStack {
                Spacer()

                Image("Cleari_Header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)

                Spacer()

                Button {
                   // print("PROFILE TAPPED")
                    onProfileTapped?()
                } label: {
                    Image(systemName: "person")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(dark)
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .zIndex(10)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            HStack(spacing: 100) {
                Button {
                   // print("EXPLORE TAPPED")
                    onExploreTapped?()
                } label: {
                    TypographyLabel(text: "explore", style: .button, color: .white)
                        .underline(activeTab == .explore)
                        .frame(height: 44)
                }
                .buttonStyle(.plain)
                Button {
                  //  print("FAKE TRENDS TAPPED")
                    onFakeTrendsTapped?()
                } label: {
                    TypographyLabel(text: "fake trends", style: .button, color: .white)
                        .frame(width: 150, height: 50)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .zIndex(10)
            }
        }
        .zIndex(10)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}
