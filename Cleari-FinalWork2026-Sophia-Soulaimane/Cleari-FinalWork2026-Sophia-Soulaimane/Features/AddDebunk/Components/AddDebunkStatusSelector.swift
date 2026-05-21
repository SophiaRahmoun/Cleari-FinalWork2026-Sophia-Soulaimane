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
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                statusButton("xmark", "Not recommend")
                statusButton("exclamationmark.triangle.fill", "Use with caution")
            }

            statusButton("checkmark", "True")
        }
    }

    private func statusButton(_ icon: String, _ title: String) -> some View {
        AddDebunkStatusButton(
            icon: icon,
            title: title,
            isSelected: selectedStatus == title
        ) {
            selectedStatus = title
        }
    }
}
