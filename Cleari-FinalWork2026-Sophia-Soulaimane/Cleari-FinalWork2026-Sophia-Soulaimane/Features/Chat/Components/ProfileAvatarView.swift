//
//  ProfileAvatarView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import SwiftUI

struct ProfileAvatarView: View {
    var imageName: String? = nil
    var imageUrl: String? = nil
    let size: CGFloat
    let action: () -> Void

    private let beige = Color(hex: "FDF3EB")
    private let darkBrown = Color(hex: "1E141D")

    var body: some View {
        Button(action: action) {
            Group {
                if let urlString = imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            placeholderView
                        }
                    }
                } else if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    placeholderView
                }
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(beige, lineWidth: 2))
            .shadow(color: darkBrown.opacity(0.18), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var placeholderView: some View {
        Circle()
            .fill(darkBrown)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(beige)
            )
    }
}
