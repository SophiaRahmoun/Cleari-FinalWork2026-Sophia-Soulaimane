//
//  UserHomeShellView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct UserHomeShellView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showFindDermatologist = false
    @State private var showScan = false
    @State private var showCalendar = false
    @State private var showChat = false
    @State private var showRequests = false

    private var isDermatologist: Bool {
        TokenStorage.shared.userRole == "dermatologist"
    }

    var body: some View {
        Group {
            if isDermatologist {
                dermatologistShell
            } else {
                userShell
            }
        }
        .navigationBarBackButtonHidden(true)
    }

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
            .fullScreenCover(isPresented: $showFindDermatologist) {
                FindDermatologistView().environmentObject(authViewModel)
            }
            .fullScreenCover(isPresented: $showScan) {
                CameraCaptureView()
            }
            .fullScreenCover(isPresented: $showCalendar) {
                MyAppointmentsView()
            }
    }

    private var dermatologistShell: some View {
        FeedView()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                dermBottomBar
                    .padding(.bottom, 8)
            }
            .fullScreenCover(isPresented: $showChat) {
                DermatologistConversationsView()
            }
            .fullScreenCover(isPresented: $showRequests) {
                DermatologistAppointmentRequestsView()
            }
    }

    private var dermBottomBar: some View {
        HStack(spacing: 0) {
            dermTab(icon: "bubble.left.and.bubble.right", isActive: showChat) { showChat = true }
            Spacer()
            dermTab(icon: "calendar", isActive: showRequests) { showRequests = true }
        }
        .padding(.horizontal, 52)
        .padding(.vertical, 12)
        .background(Color(hex: "C97A94"))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 24)
    }

    private func dermTab(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(isActive ? .white : Color(hex: "1A1018"))
        }
        .buttonStyle(.plain)
    }
}
