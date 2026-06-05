//
//  ScanHistoryView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

struct ScanHistoryView: View {
    @StateObject private var viewModel = ScanHistoryViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(hex: "1A1018"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 34)
                    .padding(.top, 60)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("My skin scans")
                                .font(AppFont.gillSwiftUI(.regular, size: 42))
                                .foregroundColor(Color(hex: "1A1018"))

                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color(hex: "1A1018"))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 40)

                            } else if viewModel.scans.isEmpty {
                                Text("No past scans yet. Take your first scan to get started.")
                                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                                    .foregroundColor(Color(hex: "1A1018").opacity(0.7))
                                    .padding(.top, 20)

                            } else {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.scans) { record in
                                        NavigationLink(destination: ScanHistoryDetailView(record: record)) {
                                            scanRow(record)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                                    .foregroundColor(Color(hex: "1A1018"))
                            }
                        }
                        .padding(.horizontal, 34)
                        .padding(.top, 26)
                        .padding(.bottom, 40)
                    }
                }
            }
            .task { await viewModel.fetchHistory() }
        }
    }

    private func scanRow(_ record: ScanHistoryRecord) -> some View {
        HStack(spacing: 16) {
            if let url = record.displayImageUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty:
                        Color(hex: "EDD9C8").overlay(ProgressView().scaleEffect(0.6))
                    default:
                        Color(hex: "EDD9C8").overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(Color(hex: "C66F8C").opacity(0.4))
                        )
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "EDD9C8"))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .foregroundColor(Color(hex: "C66F8C"))
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(record.formattedDate)
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(.white)

                if let scan = record.parsedScan {
                    Text(scan.recommendation.skinTypeEstimate ?? "Skin analysis")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.white.opacity(0.8))
                } else {
                    Text("Tap to view details")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(hex: "1A1018"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
