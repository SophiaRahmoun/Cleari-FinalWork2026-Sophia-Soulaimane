//
//  AddDebunkView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct AddDebunkView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var trendLink: String = ""
    @State private var selectedStatus: String?
    @State private var message: String = ""

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                AddDebunkHeader {
                    dismiss()
                }

                VStack(alignment: .leading, spacing: 18) {
                    AddDebunkSectionTitle("Select trend debunk")

                    AddDebunkInputField(
                        placeholder: "Put your link...",
                        text: $trendLink
                    )
                    .frame(height: 55)

                    AddDebunkStatusSelector(selectedStatus: $selectedStatus)

                    AddDebunkSectionTitle("Add your message")

                    AddDebunkMessageCardCompact(
                        message: $message,
                        imageName: "ProfileSample",
                        name: "Dr. Sarah Ben Ali",
                        role: "Dermatologist"
                    )

                    AddDebunkSectionTitle("Media")

                    AddDebunkMediaPicker {
                        print("Pick media tapped")
                    }
                    .frame(height: 70)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                AddDebunkActionsBar {
                    dismiss()
                } onPost: {
                    print("Post tapped")
                }
            }
        }
    }
}
