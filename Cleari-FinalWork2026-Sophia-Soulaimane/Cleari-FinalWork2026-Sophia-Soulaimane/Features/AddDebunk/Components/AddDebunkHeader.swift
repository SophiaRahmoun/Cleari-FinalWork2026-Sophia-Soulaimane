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
        VStack(spacing: 18) {
            HStack {
                BackButton(action: onBack)

                Spacer()

                Text("Add Debunk")
                    .font(AppFont.gillSwiftUI(.bold, size: 28))
                    .foregroundColor(Color(hex: "1A1018"))

                Spacer()

                Color.clear.frame(width: 32)
            }

            Text("Debunk trending skincare advice\nand inform users with your expertise")
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}
