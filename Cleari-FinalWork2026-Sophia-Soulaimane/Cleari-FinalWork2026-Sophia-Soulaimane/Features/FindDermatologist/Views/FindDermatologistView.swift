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
    @State private var selectedCity: String? = nil
    @State private var showLocationPicker = false
    @State private var showScan = false
    @State private var showCalendar = false

    // Villes uniques extraites des dermatologues chargés
    private var availableCities: [String] {
        let cities = viewModel.dermatologists.compactMap { $0.city }
        return Array(Set(cities)).sorted()
    }

    // Liste filtrée selon genre + ville
    private var filteredDermatologists: [Dermatologist] {
        viewModel.dermatologists.filter { derm in
            let genderMatch = selectedGender == "Any" || derm.gender == selectedGender
            let cityMatch   = selectedCity == nil || derm.city == selectedCity
            return genderMatch && cityMatch
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 26) {
                        TypographyLabel(
                            text: "Recommended\ndermatologist",
                            style: .h1,
                            color: Color(hex: "1A1018")
                        )
                        .padding(.top, 60)

                        // ── Filtres ──
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                filterButton("Any")
                                filterButton("Male")
                                filterButton("Female")

                                // Bouton Location
                                Button {
                                    showLocationPicker = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(selectedCity ?? "Location")
                                            .font(AppFont.gillSwiftUI(selectedCity != nil ? .bold : .regular, size: 14))

                                        if selectedCity != nil {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCity != nil
                                            ? Color(hex: "1A1018")
                                            : Color.white.opacity(0.001)
                                    )
                                    .foregroundColor(selectedCity != nil ? .white : Color(hex: "1A1018"))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(hex: "1A1018"), lineWidth: 1.5)
                                    )
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                                .simultaneousGesture(
                                    TapGesture().onEnded {
                                        if selectedCity != nil {
                                            selectedCity = nil
                                        } else {
                                            showLocationPicker = true
                                        }
                                    }
                                )
                            }
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
                            Text("No dermatologists found for this location.")
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
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerSheet(
                    cities: availableCities,
                    selectedCity: $selectedCity
                )
                .presentationDetents([.medium])
            }
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

// ── Sheet de sélection de ville ──
struct LocationPickerSheet: View {
    let cities: [String]
    @Binding var selectedCity: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Select a city")
                    .font(AppFont.gillSwiftUI(.bold, size: 20))
                    .foregroundColor(Color(hex: "1A1018"))
                Spacer()
                Button {
                    selectedCity = nil
                    dismiss()
                } label: {
                    Text("Reset")
                        .font(AppFont.gillSwiftUI(.regular, size: 15))
                        .foregroundColor(Color(hex: "C66F8C"))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 16)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(cities, id: \.self) { city in
                        Button {
                            selectedCity = city
                            dismiss()
                        } label: {
                            HStack {
                                Text(city)
                                    .font(AppFont.gillSwiftUI(selectedCity == city ? .bold : .regular, size: 17))
                                    .foregroundColor(Color(hex: "1A1018"))
                                Spacer()
                                if selectedCity == city {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color(hex: "C66F8C"))
                                        .font(.system(size: 15, weight: .bold))
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}

#Preview {
    FindDermatologistView()
}
