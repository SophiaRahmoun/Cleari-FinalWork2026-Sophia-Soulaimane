//
//  ScanResultView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct ScanResultView: View {
    let scanImage: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BeigeBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        header

                        Text("Scanned 2 min ago")
                            .font(AppFont.gillSwiftUI(.regular, size: 14))
                            .foregroundColor(.black)

                        ScanResultImage(image: scanImage)

                        chips

                        insights

                        PrimaryButton(title: "confirm") {
                            dismiss()
                        }
                        .padding(.horizontal, 80)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 45)
                    .padding(.bottom, 30)
                }

                ScanBottomBar()
            }
        }
    }

    private var header: some View {
        HStack {
            BackButton {
                dismiss()
            }

            Spacer()

            Text("Skin Analysis Result")
                .font(AppFont.gillSwiftUI(.bold, size: 28))
                .foregroundColor(.black)

            Spacer()

            Color.clear
                .frame(width: 24, height: 24)
        }
    }

    private var chips: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                ScanResultChip(title: "Hydration", value: "Low")
                ScanResultChip(title: "Redness", value: "High")
                ScanResultChip(title: "Oil Level", value: "Medium")
            }

            ScanResultChip(title: "Sensitivity", value: "Medium")
        }
        .frame(maxWidth: .infinity)
    }

    private var insights: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text("Detailes insights")
                .font(AppFont.gillSwiftUI(.italic, size: 26))
                .foregroundColor(.black)

            ScanInsightRow(
                icon: "drop",
                title: "Hydration",
                description: "Low : Your skin needs moisture.\nDon’t forget to drink some water"
            )

            ScanInsightRow(
                icon: "flame.fill",
                title: "Redness",
                description: "High: Possible irritation or\ninflammation"
            )

            ScanInsightRow(
                icon: "sparkles",
                title: "Oil Production",
                description: "High: Possible irritation or\ninflammation"
            )
        }
    }
}
