//
//  RoutineHeader.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 02/06/2026.
//

import SwiftUI

struct RoutineHeader: View {
    let onAddTapped: () -> Void
    let onBackTapped: () -> Void

    var body: some View {
        HStack {
            Button {
                onBackTapped()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundColor(.black)
            }

            Spacer()

            Text("Routines")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Button {
                onAddTapped()
            } label: {
                Text("Add")
                    .font(.system(size: 20, weight: .semibold))
                    .italic()
                    .underline()
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 40)
    }
}
