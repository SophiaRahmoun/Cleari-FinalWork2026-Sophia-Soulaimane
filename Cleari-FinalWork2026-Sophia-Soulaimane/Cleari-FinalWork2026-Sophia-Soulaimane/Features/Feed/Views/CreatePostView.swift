//
//  CreatePostView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss

    let onPostCreated: () async -> Void

    @State private var content = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isPosting = false

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

                    Button(isPosting ? "Posting..." : "Post") {
                        Task {
                            await createPost()
                        }
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPosting)
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

                    VStack(alignment: .leading, spacing: 12) {
                        TextEditor(text: $content)
                            .font(AppFont.gillSwiftUI(.regular, size: 24))
                            .foregroundColor(Color(hex: "1A1018"))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 180)
                            .overlay(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("Share your thoughts.")
                                        .font(AppFont.gillSwiftUI(.regular, size: 24))
                                        .foregroundColor(Color(hex: "1A1018").opacity(0.6))
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }
                            }

                        if let image = selectedImage {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 160)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))

                                Button {
                                    selectedImage = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                        .shadow(radius: 3)
                                }
                                .padding(8)
                            }
                        }
                    }
                }

                Button {
                    showImagePicker = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "photo")
                        Text("Add photo")
                    }
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(Color(hex: "1A1018").opacity(0.7))
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal, 34)
            .padding(.top, 70)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                selectedImage = image
            }
        }
    }

    private func createPost() async {
        isPosting = true

        do {
            try await CommunityPostService.shared.createPost(content: content, image: selectedImage)
            await onPostCreated()
            dismiss()
        } catch {
            print("ERROR CREATING POST:", error.localizedDescription)
        }

        isPosting = false
    }
}
