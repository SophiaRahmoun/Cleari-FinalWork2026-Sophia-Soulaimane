//
//  TikTokLinkPreviewView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/06/2026.
//

import SwiftUI
import WebKit
import SafariServices

struct TikTokLinkPreviewView: View {
    let urlString: String?
    let title: String?

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
            VStack(spacing: 0) {

                TikTokWebView(url: url)
                    .frame(height: 400)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 18,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 18
                        )
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text(title ?? "TikTok trend")
                        .font(AppFont.gillSwiftUI(.bold, size: 18))
                        .foregroundColor(Color(hex: "1A1018"))
                        .lineLimit(1)

                    Button {
                        showSafari = true
                    } label: {
                        Text("Open full TikTok video")
                            .font(AppFont.gillSwiftUI(.regular, size: 14))
                            .foregroundColor(Color(hex: "1A1018").opacity(0.75))
                    }
                    .buttonStyle(.plain)

                    Text(cleanUrlString)
                        .font(AppFont.gillSwiftUI(.regular, size: 12))
                        .foregroundColor(Color(hex: "1A1018").opacity(0.55))
                        .lineLimit(1)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.28))
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            }
            .sheet(isPresented: $showSafari) {
                SafariView(url: url)
            }
        }
    }
}

struct TikTokWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        loadTikTok(url, in: webView)
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            loadTikTok(url, in: webView)
        }
    }

    private func loadTikTok(_ url: URL, in webView: WKWebView) {
        var request = URLRequest(url: url)

        request.setValue(
            "Mozilla/5.0 (iPhone; CPU iPhone OS 18_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Mobile/15E148 Safari/604.1",
            forHTTPHeaderField: "User-Agent"
        )

        webView.load(request)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
