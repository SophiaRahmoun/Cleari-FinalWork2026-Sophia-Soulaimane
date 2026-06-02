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

    var body: some View {
        ZStack {
            BeigeBackground()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        header

                        Text("Scanned just now")
                            .font(AppFont.gillSwiftUI(.regular, size: 14))
                            .foregroundColor(.black)

                        ScanResultImage(image: scanImage)

                        if viewModel.isLoading {
                            VStack(spacing: 12) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.5)
                                    Text("Analyzing your skin...")
                                        .font(AppFont.gillSwiftUI(.regular, size: 18))
                                        .foregroundColor(.black)
                                }
                            }
                        
                        if let error = viewModel.errorMessage {
                                           Text(error)
                                               .font(.caption)
                                               .foregroundColor(.red)
                        }

                       if let result = viewModel.scanResult {
                           resultChips(result)
                              resultInsights(result)
                              Text("Scan completed successfully")
                                  .foregroundColor(.green)
                                  .font(.caption)
                                  .padding(.top, 8)
                          }
                                            
                                               

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
        .task {
            viewModel.selectedImage = scanImage
            await viewModel.analyzeSelectedImage()
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

    private func resultChips(_ result: SkinScan) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                ScanResultChip(title: "Hydration", value: result.insights?.first(where: { $0.key == "moisture" })?.level ?? "-")
                ScanResultChip(title: "Redness", value: result.insights?.first(where: { $0.key == "redness" })?.level ?? "-")
                ScanResultChip(title: "Oil Level", value: result.insights?.first(where: { $0.key == "oiliness" })?.level ?? "-")
            }

            ScanResultChip(title: "Skin Type", value: result.recommendation.skinTypeEstimate ?? "-")
        }
        .frame(maxWidth: .infinity)
    }

    private func resultInsights(_ result: SkinScan)-> some View {
        VStack(alignment: .leading, spacing: 28) {
            Text("Detailed insights")
                .font(AppFont.gillSwiftUI(.italic, size: 26))
                .foregroundColor(.black)
            if let advice = result.recommendation.shortAdvice {
                           Text(advice)
                               .font(AppFont.gillSwiftUI(.regular, size: 16))
                               .foregroundColor(.black)
                       }
                       ForEach(result.insights ?? []) { insight in
                           ScanInsightRow(
                               icon: iconForInsight(insight.key),
                               title: insight.title,
                               description: "\(insight.level): \(insight.shortText)\n\(insight.tip)"
                           )
                       }

                       Text("This scan is only guidance and not a medical diagnosis.")
                           .font(.caption)
                           .foregroundColor(.black.opacity(0.6))
                   }
               }

               private func iconForInsight(_ key: String) -> String {
                   switch key {
                   case "moisture": return "drop"
                   case "redness": return "flame.fill"
                   case "oiliness": return "sparkles"
                   case "acne": return "face.smiling"
                   case "texture": return "circle.grid.2x2"
                   default: return "info.circle"
                   }
               }
           }
