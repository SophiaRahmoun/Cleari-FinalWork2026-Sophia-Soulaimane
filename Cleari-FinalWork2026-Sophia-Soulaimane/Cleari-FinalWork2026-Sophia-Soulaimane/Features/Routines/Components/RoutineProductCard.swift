//
//  RoutineProductCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI

struct RoutineProductCard: View {
    let product: RoutineProduct
    let onDelete: () -> Void
    let onNameChange: (String) -> Void
    let onImageTapped: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()

                Button {
                    onDelete()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                }
            }

            Button {
                onImageTapped()
            } label: {

                if let imageData = product.imageData,
                   let uiImage = UIImage(data: imageData) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 95)
                        .clipped()
                        .cornerRadius(8)

                } else {

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
}
