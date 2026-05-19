//
//  CreatePostView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFont.gillSwiftUI(.bold, size: 18))
                    .foregroundColor(Color(hex: "1A1018"))

                    Spacer()

                    Button("Post") {
                        print("POST:", content)
                    }
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(Color(hex: "1A1018"))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.35))
                    .clipShape(Capsule())
                }

                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.gray)

                    TextEditor(text: $content)
                        .font(AppFont.gillSwiftUI(.regular, size: 24))
                        .foregroundColor(Color(hex: "1A1018"))
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 260)
                        .overlay(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Share your thoughts.")
                                    .font(AppFont.gillSwiftUI(.regular, size: 24))
                                    .foregroundColor(Color(hex: "1A1018").opacity(0.6))
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                        }
                }

                Spacer()
            }
            .padding(.horizontal, 34)
            .padding(.top, 70)
        }
    }
}
