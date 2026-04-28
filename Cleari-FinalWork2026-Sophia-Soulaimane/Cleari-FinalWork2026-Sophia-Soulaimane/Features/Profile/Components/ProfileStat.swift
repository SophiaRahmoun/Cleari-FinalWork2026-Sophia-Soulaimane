//
//  ProfileStat.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ProfileStat: View {
    let number: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(AppFont.gillSwiftUI(.bold, size: 18))
                .foregroundColor(.white)

            Text(label)
                .font(AppFont.gillSwiftUI(.bold, size: 16))
                .foregroundColor(.white)
        }
    }
}
