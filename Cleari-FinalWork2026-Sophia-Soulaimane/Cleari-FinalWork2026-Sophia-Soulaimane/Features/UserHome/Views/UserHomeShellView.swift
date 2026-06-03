//
//  UserHomeShellView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct UserHomeShellView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // User flow state
    @State private var showFindDermatologist = false
    @State private var showScan = false
    @State private var showCalendar = false

    // Dermatologist flow state
    @State private var showChat = false
    @State private var showRequests = false

    private var isDermatologist: Bool {
        TokenStorage.shared.userRole == "dermatologist"
    }

    var body: some View {
        if isDermatologist {
            dermatologistShell
        } else {
            userShell
        }
    }

    // MARK: - User bottom navigation (unchanged)

    private var userShell: some View {
        FeedView()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ScanBottomBar(
                    onHomeTapped: nil,
                    onFindDermatologistTapped: { showFindDermatologist = true },
                    onScanTapped: { showScan = true },
                    onCalendarTapped: { showCalendar = true }
                )
                .padding(.bottom, 8)
            }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showFindDermatologist) {
            FindDermatologistView()
                .environmentObject(authViewModel)
        }
        .fullScreenCover(isPresented: $showScan) {
            CameraCaptureView()
        }
        .fullScreenCover(isPresented: $showCalendar) {
            MyAppointmentsView()
        }
    }

    // MARK: - Dermatologist bottom navigation
    // Only two tabs: Messages and Appointments.
    // No skin scan tab, no user profile/head tab, no user "My skin" pages.

    private var dermatologistShell: some View {
        FeedView()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                dermBottomBar
                    .padding(.bottom, 8)
            }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showChat) {
            DermatologistConversationsView()
        }
        .fullScreenCover(isPresented: $showRequests) {
            DermatologistAppointmentRequestsView()
        }
    }

    private var dermBottomBar: some View {
        HStack(spacing: 0) {
            dermTab(icon: "bubble.left.and.bubble.right", isActive: !showRequests) { showChat = true }
            Spacer()
            dermTab(icon: "calendar", isActive: showRequests) { showRequests = true }
        }
        .padding(.horizontal, 52)
        .padding(.vertical, 18)
        .background(Color(hex: "C97A94"))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 24)
        .padding(.bottom, 30)
    }

    private func dermTab(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(isActive ? .white : Color(hex: "1A1018"))
        }
        .buttonStyle(.plain)
    }
}
