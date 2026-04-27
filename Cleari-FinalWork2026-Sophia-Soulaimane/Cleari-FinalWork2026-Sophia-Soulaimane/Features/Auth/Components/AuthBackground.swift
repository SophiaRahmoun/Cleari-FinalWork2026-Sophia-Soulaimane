//
//  AuthBackground.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthBackground: View {
    var body: some View {
        ZStack {
            Image("authBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            Color(hex: "C66F8C")
                .opacity(0.45)
                .ignoresSafeArea()
        }
    }
}


