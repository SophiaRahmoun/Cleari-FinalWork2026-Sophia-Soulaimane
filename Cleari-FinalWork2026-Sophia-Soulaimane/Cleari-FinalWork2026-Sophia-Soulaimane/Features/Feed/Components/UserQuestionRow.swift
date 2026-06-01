//
//  UserQuestionRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct UserQuestionRow: View {
    let username: String
    let timeAgo: String
    let content: String
    var avatarUrl: String? = nil

    private let dark = Color(hex: "1A1018")

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                // Avatar
                Group {
                    if let url = avatarUrl.flatMap(URL.init) {
                        AsyncImage(url: url) { phase in
                            if case .success(let img) = phase {
                                img.resizable().scaledToFill()
                            } else {
                                Circle().fill(dark.opacity(0.15))
                            }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(dark.opacity(0.4))
                    }
                }
                .frame(width: 38, height: 38)
                .clipShape(Circle())

                // Username + time
                HStack(spacing: 4) {
                    Text(username)
                        .font(AppFont.gillSwiftUI(.bold, size: 16))
                        .foregroundColor(dark)

                    Text("· \(timeAgo)")
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(dark.opacity(0.5))
                }

                Spacer()
            }

            // Post content
            Text(content)
                .font(AppFont.gillSwiftUI(.regular, size: 17))
                .foregroundColor(dark)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9").ignoresSafeArea()
        UserQuestionRow(
            username: "jules.ctm",
            timeAgo: "20h",
            content: "Does applying iron to the body reduce wrinkles?"
        )
    }
}
