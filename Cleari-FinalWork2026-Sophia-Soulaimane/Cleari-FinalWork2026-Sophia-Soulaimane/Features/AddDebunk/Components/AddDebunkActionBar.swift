//
//  AddDebunkActionBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/05/2026.
//

import SwiftUI

struct AddDebunkActionsBar: View {
    var onCancel: () -> Void
    var onPost: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            PrimaryButton(title: "cancel") {
                onCancel()
            }

            SecondaryButton(title: "post") {
                onPost()
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}
