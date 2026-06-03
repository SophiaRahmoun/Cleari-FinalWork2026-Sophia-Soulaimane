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

    // Icons default to the user-facing set; dermatologist shell overrides them.
    var homeIcon: String = "house"
    var secondIcon: String = "magnifyingglass"
    var thirdIcon: String = "cross.case"
    var fourthIcon: String = "calendar"

    var body: some View {
        HStack {
            tabButton(icon: homeIcon,   action: onHomeTapped)
            Spacer()
            tabButton(icon: secondIcon, action: onFindDermatologistTapped)
            Spacer()
            tabButton(icon: thirdIcon,  action: onScanTapped)
            Spacer()
            tabButton(icon: fourthIcon, action: onCalendarTapped)
        }
        .font(.system(size: 28, weight: .regular))
        .foregroundColor(.black)
        .padding(.horizontal, 38)
        .padding(.top, 14)
        .padding(.bottom, 26)
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
