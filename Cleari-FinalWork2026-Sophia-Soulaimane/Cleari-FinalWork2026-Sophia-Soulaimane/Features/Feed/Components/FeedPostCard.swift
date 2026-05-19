//
//  FeedPostCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct FeedPostCard: View {
    let post: CommunityPost
    let onLikeTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(post.User.username)
                            .font(AppFont.gillSwiftUI(.bold, size: 18))
                            .foregroundColor(Color(hex: "1A1018"))
                        
                        Text("· now")
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                    Text(post.content)
                        .font(AppFont.gillSwiftUI(.regular, size: 18))
                        .foregroundColor(Color(hex: "1A1018"))
                        .lineSpacing(4)
                    
                    if let imageUrl = post.imageUrl {
                        AsyncImage(url: URL(string: "http://localhost:4000\(imageUrl)")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.white.opacity(0.25)
                        }
                        .frame(height: 190)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    
                    PostActionsRow(
                        likesCount: post.likesCount ?? 0,
                        isLiked: post.isLikedByCurrentUser ?? false,
                        onLikeTapped: onLikeTapped
                    )
                    .padding(.top, 6)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
        }
    }
}
