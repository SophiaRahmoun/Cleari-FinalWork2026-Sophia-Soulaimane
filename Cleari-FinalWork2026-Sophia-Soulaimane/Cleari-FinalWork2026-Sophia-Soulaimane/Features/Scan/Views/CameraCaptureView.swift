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

    var body: some View {
        ZStack {
            CameraPreview(cameraSession: viewModel.cameraSession)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.35))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)
                    Spacer()
                }

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
