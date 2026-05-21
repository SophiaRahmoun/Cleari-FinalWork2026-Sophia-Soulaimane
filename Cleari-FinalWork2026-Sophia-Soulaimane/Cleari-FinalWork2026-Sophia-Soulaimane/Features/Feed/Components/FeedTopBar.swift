//
//  FeedTopBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct FeedTopBar: View {
    var onFakeTrendsTapped: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()

                TypographyLabel(
                    text: "cleari",
                    style: .h2,
                    color: .white,
                    alignment: .center
                )

                Spacer()

                Image(systemName: "person")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)

            HStack {
                Spacer()

                TypographyLabel(
                    text: "explore",
                    style: .button,
                    color: .black,
                    alignment: .center
                )
                .underline()

                Spacer()

                Button {
                    onFakeTrendsTapped?()
                } label: {
                    TypographyLabel(
                        text: "fake trends",
                        style: .button,
                        color: .black,
                        alignment: .center
                    )
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(.top, 10)
    }
}
