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
        ZStack(alignment: .bottom) {
            FeedView()

            ScanBottomBar(
                onHomeTapped: nil, // Already on home
                onFindDermatologistTapped: { showFindDermatologist = true },
                onScanTapped: { showScan = true },
                onCalendarTapped: { showCalendar = true }
            )
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
        ZStack(alignment: .bottom) {
            FeedView()

            dermBottomBar
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
        HStack {
            dermTab(icon: "bubble.left.and.bubble.right", label: "Messages") { showChat = true }
            Spacer()
            dermTab(icon: "calendar", label: "Appointments") { showRequests = true }
        }
        .padding(.horizontal, 60)
        .padding(.top, 14)
        .padding(.bottom, 26)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "F9BDB9"))
        .contentShape(Rectangle())
    }

    private func dermTab(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .regular))
                Text(label)
                    .font(AppFont.gillSwiftUI(.regular, size: 12))
            }
            .foregroundColor(.black)
        }
        .buttonStyle(.plain)
    }
}
