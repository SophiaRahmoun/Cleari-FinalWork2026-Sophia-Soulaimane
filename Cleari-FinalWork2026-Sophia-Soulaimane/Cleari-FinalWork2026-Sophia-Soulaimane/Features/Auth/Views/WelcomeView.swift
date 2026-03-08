//
//  WelcomeView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct WelcomeView: View {
    private let textColor = Color(hex: "1E141D")
    
    var body: some View {
        ZStack {
            RadialGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                TypographyLabel(
                    text: "On the way to your skin",
                    style: .h1,
                    color: textColor,
                    alignment: .center
                )
                .padding(.horizontal, 32)
                
                (
                    TextSpan.body("Check out the following news about ", color: textColor)
                    + TextSpan.bodyItalic("fake news", color: textColor)
                    + TextSpan.body(", be more aware of your skin, know yourself better, and help each other without any bad advice.", color: textColor)
                )
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 50)
                
                PrimaryButton(title: "NEXT STEP") {
                    print("Next step tapped")
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                
                Spacer()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
