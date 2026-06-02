//
//  RoutineView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI

struct RoutineView: View {
    @StateObject private var viewModel = RoutineViewModel()

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
                    viewModel.addProduct()
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
    }
}
