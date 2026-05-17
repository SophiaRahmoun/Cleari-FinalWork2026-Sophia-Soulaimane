//
//  FeedPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedPostCard: View {

    let post: CommunityPost

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Image("dr_naak")
                    .resizable()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 2) {

                    Text(post.User.username)
                        .font(.headline)

                    Text("Community member")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "checkmark.seal")
                    .foregroundColor(Color.bonni)
            }

            Divider()

            Text(post.content)
                .font(.body)
        }
        .padding()
        .frame(minHeight: 200)
        .background(Color.accentColor)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
    }
}
