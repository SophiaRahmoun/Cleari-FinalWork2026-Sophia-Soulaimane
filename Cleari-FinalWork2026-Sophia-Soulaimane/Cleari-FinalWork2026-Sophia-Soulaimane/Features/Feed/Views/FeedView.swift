//
//  FeedView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        VStack(spacing: 0) {
            FeedTopBar()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
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
