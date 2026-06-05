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
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            Spacer()

            Text("Routines")
                .font(AppFont.gillSwiftUI(.regular, size: 34))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()

            Button {
                onAddTapped()
            } label: {
                Text("Add")
                    .font(AppFont.gillSwiftUI(.bold, size: 18))
                    .foregroundColor(Color(hex: "1A1018"))
                    .underline()
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 40)
    }
}
