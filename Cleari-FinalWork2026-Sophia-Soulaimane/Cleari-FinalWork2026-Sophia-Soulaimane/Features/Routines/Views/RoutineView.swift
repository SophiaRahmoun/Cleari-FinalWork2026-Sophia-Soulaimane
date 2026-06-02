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
    @State private var showCameraPicker = false
    @Environment(\.dismiss) private var dismiss
    @State private var showAddOptions = false

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
        .confirmationDialog(
            "Add product photo",
            isPresented: $showAddOptions,
            titleVisibility: .visible
        ) {
            Button("Take photo") {
                showCameraPicker = true
            }

            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                Text("Choose from library")
            }

            Button("Cancel", role: .cancel) {}
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
