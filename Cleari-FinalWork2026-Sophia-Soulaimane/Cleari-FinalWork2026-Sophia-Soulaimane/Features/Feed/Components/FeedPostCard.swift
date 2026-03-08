//
//  FeedPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedPostCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image("dr_naak")
                //Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Dr. Naak Mouloud")
                        .font(.headline)

                    Text("Dermatologist")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "checkmark.seal")
                    .foregroundColor(Color.bonni)
            }

            Divider()

            Text("No applying heat like ironing won't reduce wrinkles. In fact, it can irritate the skin and lead to burns or damage.")
                .font(.body)
        }
        .padding()
        .frame(minHeight: 200)
        .background(Color.accentColor)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .border(Color.red)}
}

#Preview {
    FeedPostCard()
}
