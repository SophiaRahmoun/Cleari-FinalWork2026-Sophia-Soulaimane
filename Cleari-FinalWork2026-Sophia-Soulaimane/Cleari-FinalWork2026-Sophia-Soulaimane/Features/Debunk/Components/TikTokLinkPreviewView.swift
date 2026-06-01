//
//  TikTokLinkPreviewView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/06/2026.
//

import SwiftUI
import SafariServices

struct TikTokLinkPreviewView: View {
    let urlString: String?

    @State private var showSafari = false

    private var cleanUrlString: String {
        urlString?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private var url: URL? {
        URL(string: cleanUrlString)
    }

    var body: some View {
        if let url, !cleanUrlString.isEmpty {
            Button {
                showSafari = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.25))
                        .frame(height: 220)

                    VStack(spacing: 12) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 52))
                            .foregroundColor(Color(hex: "1A1018"))

                        Text("Watch TikTok video")
                            .font(AppFont.gillSwiftUI(.bold, size: 22))
                            .foregroundColor(Color(hex: "1A1018"))

                        Text("Tap to open the trend")
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(Color(hex: "1A1018").opacity(0.75))
                    }
                }
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showSafari) {
                SafariView(url: url)
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
