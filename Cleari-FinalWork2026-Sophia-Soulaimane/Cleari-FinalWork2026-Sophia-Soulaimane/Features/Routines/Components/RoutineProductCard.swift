//
//  RoutineProductCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI
import PhotosUI

struct RoutineProductCard: View {
    let product: RoutineProduct
    let onDelete: () -> Void
    let onNameChange: (String) -> Void
    let onImageChange: (Data) -> Void

    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "1A1018").opacity(0.7))
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                productImageView
            }
            .buttonStyle(.plain)
            .onChange(of: selectedPhoto) { newPhoto in
                Task {
                    guard let data = try? await newPhoto?.loadTransferable(type: Data.self) else { return }
                    onImageChange(data)
                    selectedPhoto = nil
                }
            }
            .padding(.horizontal, 12)

            TextField(
                "Product name",
                text: Binding(
                    get: { product.name },
                    set: { onNameChange($0) }
                )
            )
            .font(AppFont.gillSwiftUI(.regular, size: 14))
            .foregroundColor(Color(hex: "1A1018"))
            .multilineTextAlignment(.center)
            .textFieldStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.top, 8)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "FDF3EB"))
        )
        .shadow(color: Color(hex: "C66F8C").opacity(0.15), radius: 12, x: 0, y: 6)
    }

    private var productImageView: some View {
        Group {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .clipped()
                    .cornerRadius(12)
            } else if let imageUrl = product.imageUrl,
                      let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 110)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 110)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
    }

    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(hex: "C66F8C").opacity(0.12))
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .overlay {
                VStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(Color(hex: "C66F8C").opacity(0.7))
                    Text("Add photo")
                        .font(AppFont.gillSwiftUI(.regular, size: 12))
                        .foregroundColor(Color(hex: "C66F8C").opacity(0.7))
                }
            }
    }
}
