//
//  ScanBottomBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 28/04/2026.
//

import SwiftUI

struct ScanBottomBar: View {
    var onHomeTapped: (() -> Void)?
    var onFindDermatologistTapped: (() -> Void)?
    var onScanTapped: (() -> Void)?
    var onCalendarTapped: (() -> Void)?

    var body: some View {
        HStack {
            tabButton(icon: "house",          action: onHomeTapped)
            Spacer()
            tabButton(icon: "magnifyingglass", action: onFindDermatologistTapped)
            Spacer()
            tabButton(icon: "cross.case",      action: onScanTapped)
            Spacer()
            tabButton(icon: "calendar",        action: onCalendarTapped)
        }
        .font(.system(size: 28, weight: .regular))
        .foregroundColor(.black)
        .padding(.horizontal, 38)
        .padding(.top, 14)
        .padding(.bottom, 26)
        // Solid background blocks touch pass-through to views beneath the bar
        .background(Color(hex: "F9BDB9"))
        .contentShape(Rectangle())
    }

    private func tabButton(icon: String, action: (() -> Void)?) -> some View {
        Button {
            action?()
        } label: {
            Image(systemName: icon)
        }
        .buttonStyle(.plain)
    }
}
