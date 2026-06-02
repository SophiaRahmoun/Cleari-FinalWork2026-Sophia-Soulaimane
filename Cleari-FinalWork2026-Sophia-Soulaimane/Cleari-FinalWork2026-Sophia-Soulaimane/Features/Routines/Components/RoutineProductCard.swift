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

            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 90)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
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
