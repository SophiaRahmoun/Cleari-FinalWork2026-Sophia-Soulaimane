//
//  CameraCaptureView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct CameraCaptureView: View {
    @StateObject private var viewModel = ScanViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showFindDermatologist = false
    @State private var showCalendar = false

    var body: some View {
        ZStack {
            CameraPreview(cameraSession: viewModel.cameraSession)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Button {
                    viewModel.takePhoto()
                } label: {
                    Circle()
                        .stroke(.white, lineWidth: 6)
                        .frame(width: 78, height: 78)
                        .overlay {
                            Circle()
                                .fill(.white.opacity(0.25))
                                .frame(width: 62, height: 62)
                        }
                }
                .padding(.bottom, 16)

                ScanBottomBar(
                    onHomeTapped: { dismiss() },
                    onFindDermatologistTapped: { showFindDermatologist = true },
                    onScanTapped: nil,
                    onCalendarTapped: { showCalendar = true },
                    activeTab: 2
                )
                .padding(.bottom, 8)
            }
        }
        .fullScreenCover(isPresented: $showFindDermatologist) { FindDermatologistView() }
        .fullScreenCover(isPresented: $showCalendar) { MyAppointmentsView() }
        .onAppear {
            viewModel.checkCameraPermission()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.scanImage != nil },
            set: { if !$0 { viewModel.scanImage = nil } }
        )) {
            if let image = viewModel.scanImage {
                ScanResultView(scanImage: image)
            }
        }
    }
}

#Preview {
    CameraCaptureView()
}
