//
//  ScanResultView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct ScanResultView: View {
    @StateObject private var viewModel = SkinScanViewModel()
    let scanImage: UIImage
    @Environment(\.dismiss) private var dismiss

    private let dark = Color(hex: "1E141D")
    private let pink = Color(hex: "C66F8C")

    var body: some View {
        ZStack {
            BeigeBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        header

                        Text("Scanned just now")
                            .font(AppFont.gillSwiftUI(.regular, size: 13))
                            .foregroundColor(dark.opacity(0.45))

                        ScanResultImage(image: scanImage)

                        // ── Loading ──
                        if viewModel.isLoading {
                            VStack(spacing: 14) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: pink))
                                    .scaleEffect(1.3)
                                Text("Analyzing your skin…")
                                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                                    .foregroundColor(dark.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        }

                        // ── Error ──
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(AppFont.gillSwiftUI(.regular, size: 14))
                                .foregroundColor(.red.opacity(0.8))
                        }

                        // ── Results ──
                        if let result = viewModel.scanResult {
                            chipsSection(result)
                            insightsSection(result)
                        }

                        PrimaryButton(title: "Done") {
                            dismiss()
                        }
                        .padding(.horizontal, 60)
                        .padding(.top, 8)

                        // Disclaimer
                        Text("This scan provides general skin metrics and is not a medical diagnosis.")
                            .font(AppFont.gillSwiftUI(.regular, size: 12))
                            .foregroundColor(dark.opacity(0.38))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                }

                ScanBottomBar()
            }
        }
        .task {
            viewModel.selectedImage = scanImage
            await viewModel.analyzeSelectedImage()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            BackButton { dismiss() }
            Spacer()
            Text("Skin Analysis")
                .font(AppFont.gillSwiftUI(.bold, size: 26))
                .foregroundColor(dark)
            Spacer()
            Color.clear.frame(width: 24, height: 24)
        }
    }

    // MARK: - Chips (summary row)

    private func chipsSection(_ result: SkinScan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(AppFont.gillSwiftUI(.italic, size: 20))
                .foregroundColor(dark)

            // Short advice line from backend (neutral now)
            if let advice = result.recommendation.shortAdvice {
                Text(advice)
                    .font(AppFont.gillSwiftUI(.regular, size: 15))
                    .foregroundColor(dark.opacity(0.65))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ScanResultChip(
                        title: "Skin Type",
                        value: (result.recommendation.skinTypeEstimate ?? "—").capitalized
                    )
                    if let insights = result.insights {
                        ForEach(insights) { insight in
                            ScanResultChip(title: insight.title, value: insight.level)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    // MARK: - Insights list

    private func insightsSection(_ result: SkinScan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Detailed insights")
                .font(AppFont.gillSwiftUI(.italic, size: 20))
                .foregroundColor(dark)

            if let insights = result.insights {
                ForEach(insights) { insight in
                    ScanInsightRow(
                        icon: iconForInsight(insight.key),
                        title: insight.title,
                        description: insight.shortText,
                        score: insight.score,
                        tip: insight.tip
                    )
                }
            }
        }
    }

    // MARK: - Icon map (SF Symbols fitting each metric)

    private func iconForInsight(_ key: String) -> String {
        switch key {
        case "moisture":  return "drop.fill"
        case "redness":   return "waveform.path.ecg"
        case "oiliness":  return "sparkle"
        case "acne":      return "circle.dotted"
        case "texture":   return "squareshape.split.2x2"
        default:          return "info.circle"
        }
    }
}
