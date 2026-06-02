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

    var body: some View {
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
}
