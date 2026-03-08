//
//  PostActionsRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct PostActionsRow: View {
    var body: some View {
        HStack(spacing: 32) {
            
            HStack(spacing: 6) {
                Image(systemName: "heart")
                Text("30")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "bubble.right")
                Text("14")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "arrowshape.turn.up.right")
                Text("1")
            }
            
            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(.primary)
        .padding(.horizontal, 16)
    }
}

#Preview {
    PostActionsRow()
}
