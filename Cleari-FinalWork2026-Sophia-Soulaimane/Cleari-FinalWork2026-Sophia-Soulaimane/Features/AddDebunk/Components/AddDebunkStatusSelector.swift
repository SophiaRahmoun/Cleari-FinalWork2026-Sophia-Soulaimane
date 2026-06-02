//
//  AddDebunkStatusSelector.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/05/2026.
//

import SwiftUI

struct AddDebunkStatusSelector: View {
    @Binding var selectedStatus: String?

    var body: some View {
        HStack(spacing: 10) {
            statusButton(
                icon: "xmark",
                title: "Not recommend",
                color: Color(hex: "B8322A")
            )

            statusButton(
                icon: "exclamationmark.triangle.fill",
                title: "Use with caution",
                color: Color(hex: "F2B92F")
            )

            statusButton(
                icon: "checkmark",
                title: "True",
                color: Color(hex: "2F7D3C")
            )
        }
    }

    private func statusButton(icon: String, title: String, color: Color) -> some View {
        AddDebunkStatusButton(
            icon: icon,
            title: title,
            iconColor: color,
            isSelected: selectedStatus == title
        ) {
            selectedStatus = title
        }
    }
}
