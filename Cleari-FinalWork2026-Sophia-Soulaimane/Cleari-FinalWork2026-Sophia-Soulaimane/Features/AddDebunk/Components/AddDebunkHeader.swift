//
//  AddDebunkHeader.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/05/2026.
//

import SwiftUI

struct AddDebunkHeader: View {
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                BackButton(action: onBack)

                Spacer()

                Text("Add Debunk")
                    .font(AppFont.gillSwiftUI(.bold, size: 24))
                    .foregroundColor(Color(hex: "1A1018"))

                Spacer()

                Color.clear.frame(width: 22)
            }

            Text("Debunk trending skincare advice")
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(Color(hex: "1A1018"))
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
    }
}
