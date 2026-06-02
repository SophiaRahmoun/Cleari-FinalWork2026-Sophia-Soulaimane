//
//  AppointmentStatusStepper.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/05/2026.
//

import SwiftUI

struct AppointmentStatusStepper: View {
    let status: String
    private var currentStep: Int {
        switch status {
        case "pending":
            return 0
        case "confirmed":
            return 1
        case "completed":
            return 2
        default:
            return 0
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        index <= currentStep
                        ? Color(hex: "4B0015")
                        : Color.gray.opacity(0.3)
                    )
                    .frame(height: 8)
            }
        }
    }
}
