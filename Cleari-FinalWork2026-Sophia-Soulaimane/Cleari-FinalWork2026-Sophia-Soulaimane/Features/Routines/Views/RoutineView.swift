//
//  RoutineView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI
import PhotosUI

struct RoutineView: View {
    @StateObject private var viewModel = RoutineViewModel()
    @State private var selectedPhoto: PhotosPickerItem?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color("BackgroundBeige")
                .ignoresSafeArea()

            VStack {
                RoutineHeader {
                    // Add is handled by PhotosPicker
                }
                .overlay(alignment: .trailing) {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        Text("Add")
                            .font(.system(size: 18, weight: .semibold))
                            .italic()
                            .underline()
                            .foregroundColor(.black)
                            .padding(.trailing, 28)
                            .padding(.top, 40)
                    }
                }

                if viewModel.products.isEmpty {
                    EmptyRoutineMessage()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 22) {
                            ForEach(viewModel.products) { product in
                                RoutineProductCard(
                                    product: product,
                                    onDelete: {
                                        viewModel.deleteProduct(product)
                                    },
                                    onNameChange: { newName in
                                        viewModel.updateProductName(
                                            for: product,
                                            name: newName
                                        )
                                    },
                                    onImageChange: { imageData in
                                        viewModel.updateProductImage(
                                            for: product,
                                            imageData: imageData
                                        )
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 120)
                    }
                }

                Spacer()
            }
        }
        .onChange(of: selectedPhoto) { newPhoto in
            Task {
                guard let data = try? await newPhoto?.loadTransferable(type: Data.self) else {
                    return
                }

                viewModel.addProduct(imageData: data)
                selectedPhoto = nil
            }
        }
    }
}
