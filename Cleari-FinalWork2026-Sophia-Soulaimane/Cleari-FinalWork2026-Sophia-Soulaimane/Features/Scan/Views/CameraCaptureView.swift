//
//  CameraCaptureView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct CameraCaptureView: View {
    @StateObject private var viewModel = ScanViewModel()

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
                .padding(.bottom, 55)
            }
        }
        .onAppear {
            viewModel.checkCameraPermission()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
    }
}
