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

    @Published var scanImage: UIImage?
    @Published var currentPosition: AVCaptureDevice.Position = .back

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .authorized:
            setupCamera(position: currentPosition)

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera(position: self.currentPosition)
                    }
                }
            }

        default:
            print("Camera permission denied")
        }
    }

    private func setupCamera(position: AVCaptureDevice.Position) {
        cameraSession.beginConfiguration()
        cameraSession.sessionPreset = .photo

        // Remove existing inputs
        cameraSession.inputs.forEach { cameraSession.removeInput($0) }

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let cameraInput = try? AVCaptureDeviceInput(device: camera),
              cameraSession.canAddInput(cameraInput) else {
            cameraSession.commitConfiguration()
            return
        }

        cameraSession.addInput(cameraInput)

        if cameraSession.outputs.isEmpty {
            guard cameraSession.canAddOutput(photoOutput) else {
                cameraSession.commitConfiguration()
                return
            }
            cameraSession.addOutput(photoOutput)
        }

        cameraSession.commitConfiguration()

        if !cameraSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.cameraSession.startRunning()
            }
        }
    }

    func flipCamera() {
        currentPosition = currentPosition == .back ? .front : .back
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupCamera(position: self.currentPosition)
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

// Important
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

        DispatchQueue.main.async {
            self.scanImage = image
        }
    }
}
