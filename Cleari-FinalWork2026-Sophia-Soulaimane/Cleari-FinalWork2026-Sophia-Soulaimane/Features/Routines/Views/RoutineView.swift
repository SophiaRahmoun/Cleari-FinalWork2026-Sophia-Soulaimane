//
//  RoutineView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI

struct RoutineView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = RoutineViewModel()

    @State private var showAddOptions = false
    @State private var showCameraPicker = false
    @State private var showLibraryPicker = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color("BackgroundBeige")
                .ignoresSafeArea()

            VStack {
                RoutineHeader(
                    onAddTapped: {
                        showAddOptions = true
                    },
                    onBackTapped: {
                        dismiss()
                    }
                )

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
        .confirmationDialog(
            "Add product photo",
            isPresented: $showAddOptions,
            titleVisibility: .visible
        ) {
            Button("Take photo") {
                showCameraPicker = true
            }

            Button("Choose from library") {
                showLibraryPicker = true
            }

            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(
                onImagePicked: { imageData in
                    viewModel.addProduct(imageData: imageData)
                },
                onDismiss: {
                    showCameraPicker = false
                }
            )
        }
        .sheet(isPresented: $showLibraryPicker) {
            PhotoLibraryPicker(
                onImagePicked: { imageData in
                    viewModel.addProduct(imageData: imageData)
                },
                onDismiss: {
                    showLibraryPicker = false
                }
            )
        }
    }
}
