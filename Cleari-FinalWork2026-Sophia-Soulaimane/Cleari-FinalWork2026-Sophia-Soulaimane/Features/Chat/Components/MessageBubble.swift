//
//  MessageBubble.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 31/05/2026.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    let isCurrentUser: Bool
    let currentUserProfileImage: String
    let otherUserProfileImage: String
    let onProfileTap: () -> Void

    private let beige = Color(hex: "FDF3EB")
    private let pink = Color(hex: "C66F8C")
    private let darkBrown = Color(hex: "1E141D")

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !isCurrentUser {
                ProfileAvatarView(
                    imageName: otherUserProfileImage,
                    size: 38,
                    action: onProfileTap
                )
            }

            bubbleContent
                .frame(maxWidth: 260, alignment: isCurrentUser ? .trailing : .leading)

            if isCurrentUser {
                ProfileAvatarView(
                    imageName: currentUserProfileImage,
                    size: 38,
                    action: onProfileTap
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
        .padding(.horizontal, 18)
    }

    @ViewBuilder
    private var bubbleContent: some View {
        if message.messageType == "image", let url = URL(string: message.content) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        } else if message.messageType == "appointment_request" {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(beige)
                TypographyLabel(text: message.content, style: .body, color: beige)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(darkBrown.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            TypographyLabel(
                text: message.content,
                style: .body,
                color: beige
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isCurrentUser ? pink.opacity(0.9) : darkBrown.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
