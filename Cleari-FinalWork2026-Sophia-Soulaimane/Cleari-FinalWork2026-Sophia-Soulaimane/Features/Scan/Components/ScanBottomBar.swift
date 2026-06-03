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

    var activeTab: Int = 0 // 0=home, 1=search, 2=scan, 3=calendar

    var homeIcon: String = "house"
    var secondIcon: String = "magnifyingglass"
    var thirdIcon: String = "cross.case"
    var fourthIcon: String = "calendar"

    private let active = Color.white
    private let inactive = Color(hex: "1A1018")
    private let bg = Color(hex: "C97A94")

    var body: some View {
        HStack(spacing: 0) {
            tabButton(icon: homeIcon,   index: 0, action: onHomeTapped)
            Spacer()
            tabButton(icon: secondIcon, index: 1, action: onFindDermatologistTapped)
            Spacer()
            tabButton(icon: thirdIcon,  index: 2, action: onScanTapped)
            Spacer()
            tabButton(icon: fourthIcon, index: 3, action: onCalendarTapped)
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 18)
        .background(bg)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 24)
        .padding(.bottom, 44)
    }

    private func tabButton(icon: String, index: Int, action: (() -> Void)?) -> some View {
        Button {
            action?()
        } label: {
            Image(systemName: icon)
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(activeTab == index ? active : inactive)
        }
        .buttonStyle(.plain)
    }
}
