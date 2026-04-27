//
//  AuthDocumentUploadBox.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthDocumentUploadBox: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("AccentColor"))
                    .shadow(color: .black.opacity(0.12), radius: 8, y: 5)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 32, weight: .regular))
                    .foregroundColor(.black)
            }
            .frame(height: 78)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        RadialGradientBackground(
            startHex: "C66F8C",
            endHex: "F9BDB9"
        )
        .ignoresSafeArea()

        AuthDocumentUploadBox {
            print("upload tapped")
        }
        .padding(.horizontal, 32)
    }
}
