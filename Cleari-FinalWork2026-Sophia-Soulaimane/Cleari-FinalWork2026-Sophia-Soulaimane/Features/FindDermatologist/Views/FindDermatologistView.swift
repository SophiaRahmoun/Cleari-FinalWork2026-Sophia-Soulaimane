//
//  FindDermatologistView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//

import SwiftUI

struct FindDermatologistView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FindDermatologistViewModel()
    @State private var selectedGender = "Any"
    @State private var showScan = false
    @State private var showCalendar = false

    private var filteredDermatologists: [Dermatologist] {
        viewModel.dermatologists
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 26) {
                        Text("Recommended\ndermatologist")
                            .font(AppFont.gillSwiftUI(.regular, size: 42))
                            .foregroundColor(Color(hex: "1A1018"))
                            .lineSpacing(4)
                            .padding(.top, 60)

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
                            Text("No verified dermatologists available yet.")
                                .font(AppFont.gillSwiftUI(.regular, size: 16))
                                .foregroundColor(Color(hex: "1A1018").opacity(0.7))
                                .padding(.top, 20)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(filteredDermatologists) { dermatologist in
                                    DermatologistCard(dermatologist: dermatologist)
                                        .onTapGesture {
                                            Task { await viewModel.startChat(with: dermatologist) }
                                        }
                                }
                            }
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(AppFont.gillSwiftUI(.regular, size: 14))
                                .foregroundColor(Color(hex: "1A1018"))
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 34)
                    .padding(.top, 26)
                    .padding(.bottom, 40)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    ScanBottomBar(
                        onHomeTapped: { dismiss() },
                        onFindDermatologistTapped: nil,
                        onScanTapped: { showScan = true },
                        onCalendarTapped: { showCalendar = true },
                        activeTab: 1
                    )
                    .padding(.bottom, 8)
                }
            }
            .task { await viewModel.loadDermatologists() }
            .fullScreenCover(isPresented: $showScan) { CameraCaptureView() }
            .fullScreenCover(isPresented: $showCalendar) { MyAppointmentsView() }
            .navigationDestination(item: $viewModel.selectedConversation) { conversation in
                let currentUserId = TokenStorage.shared.userId ?? 0
                let currentUserRole = TokenStorage.shared.userRole ?? "user"
                ChatDetailView(
                    conversationId: conversation.id,
                    currentUserId: currentUserId,
                    currentUserRole: currentUserRole,
                    dermatologistName: viewModel.selectedDermatologist?.displayName ?? "Dermatologist",
                    currentUserProfileImageUrl: TokenStorage.shared.profilePictureUrl,
                    dermatologistProfileImageUrl: viewModel.selectedDermatologist?.profileImageUrl
                )
            }
        }
    }

    private func filterButton(_ gender: String) -> some View {
        Button { selectedGender = gender } label: {
            DermatologistFilterLabel(title: gender, isSelected: selectedGender == gender)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FindDermatologistView()
}
