//
//  DocumentPicker.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 23/05/2026.
//


import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    let onDocumentSelected: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf, .image, .plainText, .data],
            asCopy: true
        )

        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentSelected: onDocumentSelected)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onDocumentSelected: (URL) -> Void

        init(onDocumentSelected: @escaping (URL) -> Void) {
            self.onDocumentSelected = onDocumentSelected
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onDocumentSelected(url)
        }
    }
}
