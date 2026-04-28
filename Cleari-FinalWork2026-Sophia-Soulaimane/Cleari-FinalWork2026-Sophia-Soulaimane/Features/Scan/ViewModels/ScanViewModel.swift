//
//  ScanViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI
import AVFoundation

final class ScanViewModel: NSObject, ObservableObject {

    let cameraSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .authorized:
            setupCamera()
            print("setupCamera started")

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }

        default:
            print("Camera permission denied")
        }
    }

    private func setupCamera() {
        cameraSession.beginConfiguration()
        cameraSession.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let cameraInput = try? AVCaptureDeviceInput(device: camera),
              cameraSession.canAddInput(cameraInput),
              cameraSession.canAddOutput(photoOutput) else {
            return
        }

        cameraSession.addInput(cameraInput)
        cameraSession.addOutput(photoOutput)

        cameraSession.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraSession.startRunning()
            print("camera starting")
        }
    }

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func stopCamera() {
        if cameraSession.isRunning {
            cameraSession.stopRunning()
        }
    }
}

extension ScanViewModel: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error = error {
            print("Photo error:", error)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }

        print("Photo taken:", image)
    }
}
