//
//  RoutineHeader.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI

struct RoutineHeader: View {
    let onAddTapped: () -> Void

    var body: some View {
        HStack {
            Button {
                // Back action later
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }

            Spacer()

            Text("Routines")
                .font(.system(size: 28, weight: .bold))

            Spacer()

            Color.clear
                .frame(width: 45, height: 30)
        }
        .padding(.horizontal, 28)
        .padding(.top, 40)
    }
}
