//
//  PatientScansView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

struct PatientScansView: View {
    let conversationId: Int
    @Environment(\.dismiss) private var dismiss
    @State private var scans: [PatientScanRecord] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                BeigeBackground()

                Group {
                    if isLoading {
                        ProgressView()
                            .tint(Color(hex: "C66F8C"))
                    } else if scans.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 44))
                                .foregroundColor(Color(hex: "C66F8C").opacity(0.4))
                            Text("No scans available for this patient.")
                                .font(AppFont.gillSwiftUI(.regular, size: 16))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 24) {
                                ForEach(scans) { scan in
                                    scanCard(scan)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationTitle("Patient Scans")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(hex: "1A1018"))
                    }
                }
            }
            .task { await loadScans() }
        }
    }

    private func scanCard(_ scan: PatientScanRecord) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(scan.formattedDate)
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(.black.opacity(0.5))

            // Cloudinary image
            if let url = scan.displayImageUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                            .frame(maxWidth: .infinity).frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    case .empty:
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "EDD9C8")).frame(height: 220)
                            .overlay(ProgressView().tint(Color(hex: "C66F8C")))
                    default:
                        scanPlaceholder
                    }
                }
            } else {
                scanPlaceholder
            }

            // Insights
            if let brief = scan.parsedSkinScan {
                if let type = brief.recommendation?.skinTypeEstimate {
                    Text("Skin type: \(type)")
                        .font(AppFont.gillSwiftUI(.bold, size: 15))
                        .foregroundColor(.black)
                }
                if let advice = brief.recommendation?.shortAdvice {
                    Text(advice)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.black.opacity(0.7))
                }
                ForEach(brief.insights ?? []) { insight in
                    HStack(spacing: 10) {
                        Circle().fill(statusColor(insight.level))
                            .frame(width: 8, height: 8)
                        Text("\(insight.title): \(insight.level)")
                            .font(AppFont.gillSwiftUI(.regular, size: 14))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private var scanPlaceholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "EDD9C8")).frame(height: 220)
            .overlay(
                Image(systemName: "camera.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "C66F8C").opacity(0.4))
            )
    }

    private func statusColor(_ level: String) -> Color {
        switch level.lowercased() {
        case "high":   return Color(hex: "E05C5C")
        case "medium": return Color(hex: "C66F8C")
        default:       return Color(hex: "4CAF82")
        }
    }

    private func loadScans() async {
        isLoading = true
        do {
            scans = try await ChatService.shared.fetchPatientScans(conversationId: conversationId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
