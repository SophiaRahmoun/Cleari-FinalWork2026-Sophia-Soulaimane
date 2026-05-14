//
//  UserHomeShellView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct UserHomeShellView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            FeedView()

            ScanBottomBar()
        }
        .navigationBarBackButtonHidden(true)
    }
}
