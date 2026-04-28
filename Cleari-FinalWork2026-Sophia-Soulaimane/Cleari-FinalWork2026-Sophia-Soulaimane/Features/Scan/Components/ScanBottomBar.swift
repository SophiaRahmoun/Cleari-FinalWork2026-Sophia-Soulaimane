//
//  ScanBottomBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ScanBottomBar: View {
    var body: some View {
        HStack {
            Image(systemName: "house")
            Spacer()
            Image(systemName: "magnifyingglass")
            Spacer()
            Image(systemName: "cross.case")
            Spacer()
            Image(systemName: "calendar")
        }
        .font(.system(size: 28, weight: .regular))
        .foregroundColor(.black)
        .padding(.horizontal, 38)
        .padding(.top, 14)
        .padding(.bottom, 26)
    }
}
