//
//  FeedTopBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct FeedTopBar: View {
    var body: some View {
        VStack(spacing: 16) {
            
            // Top row
            HStack {
                
                Spacer()
                
                Text("cleari")
                    .font(.system(size: 28, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "person")
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 20)
            
            
            // Tabs
            HStack {
                
                Spacer()
                
                Text("explore")
                    .font(.system(size: 16, weight: .semibold))
                    .underline()
                
                Spacer()
                
                Text("fake trends")
                    .font(.system(size: 16))
                
                Spacer()
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    FeedTopBar()
}
