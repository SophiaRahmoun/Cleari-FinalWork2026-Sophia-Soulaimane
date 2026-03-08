//
//  UserQuestionRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 08/03/2026.
//

import SwiftUI

struct UserQuestionRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(spacing: 10) {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)
                
                Text("jules.ctm · 20h")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Text("Does applying iron to the body reduce wrinkles?")
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    UserQuestionRow()
}
