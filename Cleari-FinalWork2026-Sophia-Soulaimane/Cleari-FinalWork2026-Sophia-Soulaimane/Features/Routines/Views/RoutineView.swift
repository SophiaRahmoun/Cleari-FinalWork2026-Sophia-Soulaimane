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
            RadialGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                RoutineHeader(
                    onAddTapped: { showAddOptions = true },
                    onBackTapped: { dismiss() }
                )
                .padding(.bottom, 8)

                if viewModel.products.isEmpty {
                    EmptyRoutineMessage()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.products) { product in
                                RoutineProductCard(
                                    product: product,
                                    onDelete: { viewModel.deleteProduct(product) },
                                    onNameChange: { viewModel.updateProductName(for: product, name: $0) },
                                    onImageChange: { viewModel.updateProductImage(for: product, imageData: $0) }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .confirmationDialog("Add product photo", isPresented: $showAddOptions, titleVisibility: .visible) {
            Button("Take photo") { showCameraPicker = true }
            Button("Choose from library") { showLibraryPicker = true }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(
                onImagePicked: { viewModel.addProduct(imageData: $0) },
                onDismiss: { showCameraPicker = false }
            )
        }
        .sheet(isPresented: $showLibraryPicker) {
            PhotoLibraryPicker(
                onImagePicked: { viewModel.addProduct(imageData: $0) },
                onDismiss: { showLibraryPicker = false }
            )
        }
        .alert("Sync Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred.")
        }
    }
}
