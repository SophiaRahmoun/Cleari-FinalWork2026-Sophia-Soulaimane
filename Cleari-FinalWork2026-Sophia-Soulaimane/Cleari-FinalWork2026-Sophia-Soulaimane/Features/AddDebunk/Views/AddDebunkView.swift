//
//  AddDebunkView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 30/04/2026.
//

import SwiftUI

struct AddDebunkView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddDebunkViewModel()

    @State private var title = ""
    @State private var trendName = ""
    @State private var description = ""
    @State private var trendLink = ""
    @State private var selectedStatus: String?
    @State private var message = ""

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    AddDebunkHeader {
                        dismiss()
                    }
                    .padding(.bottom, 22)

                    AddDebunkSectionTitle("Select trend debunk")

                    VStack(spacing: 12) {
                        AddDebunkInputField(placeholder: "Debunk title...", text: $title)
                        AddDebunkInputField(placeholder: "Trend name...", text: $trendName)
                        AddDebunkInputField(placeholder: "Short description...", text: $description)
                        AddDebunkInputField(placeholder: "Put your link...", text: $trendLink)
                    }

                    AddDebunkStatusSelector(selectedStatus: $selectedStatus)
                        .padding(.top, 8)

                    AddDebunkSectionTitle("Add your message")
                        .padding(.top, 8)

                    AddDebunkMessageCard(
                        message: $message,
                        imageName: "ProfileSample",
                        name: "Dr. Sarah Ben Ali",
                        role: "Dermatologist"
                    )

                    AddDebunkSectionTitle("Add a picture or video")
                        .padding(.top, 8)

                    AddDebunkMediaPicker {
                        print("Pick media tapped")
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(AppFont.gillSwiftUI(.regular, size: 13))
                            .foregroundColor(.red)
                    }

                    AddDebunkActionsBar {
                        dismiss()
                    } onPost: {
                        Task {
                            let success = await viewModel.createDebunkPost(
                                title: title,
                                trendName: trendName,
                                description: description,
                                debunkExplanation: message,
                                tiktokUrl: trendLink,
                                status: selectedStatus
                            )

                            if success {
                                dismiss()
                            }
                        }
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 34)
                .padding(.top, 45)
                .padding(.bottom, 45)
            }
        }
    }
}
