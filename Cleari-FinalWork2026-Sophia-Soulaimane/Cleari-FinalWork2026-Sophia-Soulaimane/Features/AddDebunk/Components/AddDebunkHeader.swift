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
        VStack(spacing: 20) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(Color(hex: "1A1018"))
                }

                Spacer()

                Text("Add Debunk")
                    .font(AppFont.gillSwiftUI(.bold, size: 32))
                    .foregroundColor(Color(hex: "1A1018"))

                Spacer()

                Color.clear
                    .frame(width: 30, height: 30)
            }

            Text("Debunk trending skincare advice and inform\nusers with your expertise")
                .font(AppFont.gillSwiftUI(.bold, size: 15))
                .foregroundColor(Color(hex: "1A1018"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 34)
        .padding(.top, 70)
    }
}
