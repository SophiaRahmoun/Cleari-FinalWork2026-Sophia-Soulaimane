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
        VStack(spacing: 10) {
            HStack {
                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .zIndex(10)
            }

            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                productImageView
            }
            .buttonStyle(.plain)
            .onChange(of: selectedPhoto) { newPhoto in
                Task {
                    guard let data = try? await newPhoto?.loadTransferable(type: Data.self) else {
                        return
                    }

                    onImageChange(data)
                    selectedPhoto = nil
                }
            }

            TextField(
                "Product name",
                text: Binding(
                    get: {
                        product.name
                    },
                    set: { newValue in
                        onNameChange(newValue)
                    }
                )
            )
            .font(.system(size: 16))
            .multilineTextAlignment(.center)
            .textFieldStyle(.plain)
        }
        .padding()
        .frame(height: 190)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(radius: 8, x: 0, y: 4)
    }

    private var productImageView: some View {
        Group {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 95)
                    .clipped()
                    .cornerRadius(8)
            } else if let imageUrl = product.imageUrl,
                      let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 95)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 95)
                            .clipped()
                            .cornerRadius(8)

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
        Rectangle()
            .fill(Color.gray.opacity(0.15))
            .frame(width: 120, height: 95)
            .cornerRadius(8)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
            }
    }
}
