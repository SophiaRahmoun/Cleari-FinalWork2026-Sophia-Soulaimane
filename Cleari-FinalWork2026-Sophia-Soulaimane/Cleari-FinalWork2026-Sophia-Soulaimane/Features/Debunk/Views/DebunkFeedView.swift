//
//  DebunkFeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct DebunkFeedView: View {
    var isDermatologist: Bool = false

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 26) {
                        FeedTopBar()

                        filters

                        if isDermatologist {
                            AddDebunkButton {
                                print("Add debunk tapped")
                            }
                            .padding(.horizontal, 80)
                        }

                        DebunkPostCard(
                            title: "Does applying iron on the skin reduce wrinkles?",
                            mediaName: "DebunkSample"
                        )
                        .padding(.horizontal, 34)

                        Divider()
                            .background(Color(hex: "1A1018").opacity(0.35))

                        Text("Does applying Gold on the skin reduce wrinkles?")
                            .font(AppFont.gillSwiftUI(.bold, size: 22))
                            .foregroundColor(Color(hex: "1A1018"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 34)
                    }
                    .padding(.top, 55)
                    .padding(.bottom, 30)
                }

                DebunkReplyBar(imageName: "ProfileSample")
                    .padding(.horizontal, 34)
                    .padding(.bottom, 14)

                ScanBottomBar()
            }
        }
    }

    private var filters: some View {
        HStack(spacing: 12) {
            DermatologistFilterLabel(title: "All", isSelected: true)
            DermatologistFilterLabel(title: "Acne")
            DermatologistFilterLabel(title: "Anti-aging")
            DermatologistFilterLabel(title: "Sensitive skin")
        }
        .padding(.horizontal, 34)
    }
}
