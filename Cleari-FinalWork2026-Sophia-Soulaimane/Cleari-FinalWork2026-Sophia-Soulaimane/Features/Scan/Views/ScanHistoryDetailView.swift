//
//  ScanHistoryDetailView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

struct ScanHistoryDetailView: View {
    let record: ScanHistoryRecord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BeigeBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {

                        // Header
                        HStack {
                            BackButton { dismiss() }
                            Spacer()
                            Text("Scan Detail")
                                .font(AppFont.gillSwiftUI(.bold, size: 28))
                                .foregroundColor(.black)
                            Spacer()
                            Color.clear.frame(width: 24, height: 24)
                        }

                        Text(record.formattedDate)
                            .font(AppFont.gillSwiftUI(.regular, size: 14))
                            .foregroundColor(.black.opacity(0.6))

                        // Scan image from Cloudinary (f_jpg transform avoids HEIC issues)
                        if let url = record.displayImageUrl {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 260)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                case .empty:
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(hex: "EDD9C8"))
                                        .frame(height: 260)
                                        .overlay(ProgressView().tint(Color(hex: "C66F8C")))
                                case .failure:
                                    scanImagePlaceholder
                                @unknown default:
                                    scanImagePlaceholder
                                }
                            }
                        } else {
                            scanImagePlaceholder
                        }

                        if let scan = record.parsedScan {
                            // Chips
                            VStack(spacing: 10) {
                                HStack(spacing: 8) {
                                    ScanResultChip(title: "Hydration",
                                                   value: scan.insights?.first(where: { $0.key == "moisture" })?.level ?? "-")
                                    ScanResultChip(title: "Redness",
                                                   value: scan.insights?.first(where: { $0.key == "redness" })?.level ?? "-")
                                    ScanResultChip(title: "Oil Level",
                                                   value: scan.insights?.first(where: { $0.key == "oiliness" })?.level ?? "-")
                                }
                                ScanResultChip(title: "Skin Type",
                                               value: scan.recommendation.skinTypeEstimate ?? "-")
                            }
                            .frame(maxWidth: .infinity)

                            // Insights
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Insights")
                                    .font(AppFont.gillSwiftUI(.italic, size: 26))
                                    .foregroundColor(.black)

                                if let advice = scan.recommendation.shortAdvice {
                                    Text(advice)
                                        .font(AppFont.gillSwiftUI(.regular, size: 16))
                                        .foregroundColor(.black)
                                }

                                ForEach(scan.insights ?? []) { insight in
                                    ScanInsightRow(
                                        icon: iconForInsight(insight.key),
                                        title: insight.title,
                                        description: "\(insight.level): \(insight.shortText)\n\(insight.tip)"
                                    )
                                }
                            }
                        } else {
                            Text("No detailed insights available for this scan.")
                                .font(AppFont.gillSwiftUI(.regular, size: 15))
                                .foregroundColor(.black.opacity(0.5))
                        }

                        Text("This scan is only guidance and not a medical diagnosis.")
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.5))
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 45)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var scanImagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(hex: "EDD9C8"))
            .frame(height: 260)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "C66F8C").opacity(0.5))
                    Text("Image not available")
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(Color(hex: "7A6672"))
                }
            )
    }

    private func iconForInsight(_ key: String) -> String {
        switch key {
        case "moisture": return "drop"
        case "redness":  return "flame.fill"
        case "oiliness": return "sparkles"
        case "acne":     return "face.smiling"
        case "texture":  return "circle.grid.2x2"
        default:         return "info.circle"
        }
    }
}
