//
//  FindDermatologistView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct FindDermatologistView: View {
    @StateObject private var viewModel = FindDermatologistViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var selectedGender = "Any"

    // Gender filter is UI-only for now — backend doesn't expose gender field
    private var filteredDermatologists: [Dermatologist] {
        viewModel.dermatologists
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradientBackground(
                    startHex: "C66F8C",
                    endHex: "F9BDB9"
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 26) {
                            Text("Recommended\ndermatologist")
                                .font(AppFont.gillSwiftUI(.regular, size: 42))
                                .foregroundColor(Color(hex: "1A1018"))
                                .lineSpacing(4)

                            HStack(spacing: 8) {
                                filterButton("Any")
                                filterButton("Male")
                                filterButton("Female")
                                DermatologistFilterLabel(title: "Location")
                            }

                            Text("Top matches for you")
                                .font(AppFont.gillSwiftUI(.regular, size: 18))
                                .foregroundColor(Color(hex: "1A1018"))

                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color(hex: "1A1018"))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 20)
                            } else if filteredDermatologists.isEmpty {
                                Text("No dermatologists available yet.")
                                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                                    .foregroundColor(Color(hex: "1A1018").opacity(0.7))
                                    .padding(.top, 20)
                            } else {
                                VStack(spacing: 20) {
                                    ForEach(filteredDermatologists) { dermatologist in
                                        DermatologistCard(dermatologist: dermatologist)
                                            .onTapGesture {
                                                Task {
                                                    await viewModel.startChat(with: dermatologist)
                                                }
                                            }
                                    }
                                }
                            }

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                                    .foregroundColor(Color(hex: "1A1018"))
                            }
                        }
                        .padding(.horizontal, 34)
                        .padding(.top, 70)
                        .padding(.bottom, 120)
                    }

                    ScanBottomBar()
                }
            }
            .task {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                    await viewModel.loadDermatologists()
                }
            }
            .navigationDestination(item: $viewModel.selectedConversation) { conversation in
                if let currentUser = authViewModel.currentUser {
                    ChatDetailView(
                        conversationId: conversation.id,
                        currentUserId: currentUser.id,
                        currentUserRole: currentUser.role,
                        dermatologistName: viewModel.selectedDermatologist?.displayName ?? "Dermatologist",
                        currentUserProfileImageUrl: TokenStorage.shared.profilePictureUrl,
                        dermatologistProfileImageUrl: viewModel.selectedDermatologist?.profileImageUrl
                    )
                }
            }
        }
    }

    private func filterButton(_ gender: String) -> some View {
        Button {
            selectedGender = gender
        } label: {
            DermatologistFilterLabel(
                title: gender,
                isSelected: selectedGender == gender
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Find Dermatologist") {
    FindDermatologistView()
        .environmentObject(AuthViewModel())
}
