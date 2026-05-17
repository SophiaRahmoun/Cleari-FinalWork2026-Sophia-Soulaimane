//
//  UserQuestionRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct UserQuestionRow: View {

    let post: CommunityPost

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 10) {

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)

                Text("\(post.User.username) · now")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()
            }

            Text(post.content)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
    }
}
