//
//  ScanInsightRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ScanInsightRow: View {
    let icon: String
    let title: String
    let description: String
    var score: Int? = nil
    var tip: String? = nil

    private let pink  = Color(hex: "C66F8C")
    private let dark  = Color(hex: "1E141D")

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // ── Icon + title + score number ──
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(pink.opacity(0.12))
                        .frame(width: 38, height: 38)
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(pink)
                }

                Text(title)
                    .font(AppFont.gillSwiftUI(.bold, size: 17))
                    .foregroundColor(dark)

                Spacer()

                if let score {
                    Text("\(score)/100")
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(dark.opacity(0.45))
                }
            }

            // ── Animated score bar ──
            if let score {
                InsightScoreBar(value: score, tint: barColor(for: score))
            }

            // ── Short neutral description ──
            Text(description)
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(dark.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)

            // ── Subtle tip line ──
            if let tip, !tip.isEmpty {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "lightbulb")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(pink.opacity(0.75))
                        .padding(.top, 1)
                    Text(tip)
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(dark.opacity(0.40))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.55))
                .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        )
    }

    /// Green for low, amber for moderate, pink for elevated
    private func barColor(for score: Int) -> Color {
        if score < 35 { return Color(hex: "7CC47A") }
        if score < 65 { return Color(hex: "E8A96A") }
        return pink
    }
}

// MARK: - Score bar

struct InsightScoreBar: View {
    let value: Int      // 0–100
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(hex: "E6DED6"))
                    .frame(height: 6)
                Capsule()
                    .fill(tint)
                    .frame(width: geo.size.width * CGFloat(max(0, min(value, 100))) / 100,
                           height: 6)
                    .animation(.easeOut(duration: 0.7), value: value)
            }
        }
        .frame(height: 6)
    }
}
