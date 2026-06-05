//
//  EmptyRoutineMessage.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI

struct EmptyRoutineMessage: View {
    var body: some View {
        Spacer()

        VStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.system(size: 38, weight: .light))
                .foregroundColor(Color(hex: "1A1018").opacity(0.5))

            Text("Add your daily products")
                .font(AppFont.gillSwiftUI(.regular, size: 20))
                .foregroundColor(Color(hex: "1A1018").opacity(0.6))
                .multilineTextAlignment(.center)
        }

        Spacer()
    }
}
