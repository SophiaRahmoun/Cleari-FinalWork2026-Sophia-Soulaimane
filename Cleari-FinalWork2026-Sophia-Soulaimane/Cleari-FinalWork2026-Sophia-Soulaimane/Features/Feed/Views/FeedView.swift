//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    FeedTopBar()
                    UserQuestionRow()
                    FeedPostCard()
                    PostActionsRow()
                    ReplyBar()
                }
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    FeedView()
}
