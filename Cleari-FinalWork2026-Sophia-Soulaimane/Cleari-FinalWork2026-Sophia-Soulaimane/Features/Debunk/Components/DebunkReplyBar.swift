//
//  DebunkReplyBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct DebunkReplyBar: View {
    let imageName: String

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(imageName: imageName, size: 34)

            Text("Post your reply")
                .font(AppFont.gillSwiftUI(.bold, size: 12))
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .frame(height: 34)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "1A1018"))
                .clipShape(Capsule())
        }
    }
}
