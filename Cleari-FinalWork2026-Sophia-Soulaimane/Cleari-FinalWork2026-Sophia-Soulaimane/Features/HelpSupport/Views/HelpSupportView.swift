//
//  HelpSupportView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

//
//  HelpSupportView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var openedItemId: UUID?

    private let helpItems: [HelpSupportItem] = [
        HelpSupportItem(
            title: "Report a problem",
            description: "Tell us what went wrong so we can look into it and improve your experience.",
            iconName: "questionmark.diamond"
        ),
        HelpSupportItem(
            title: "Contact support",
            description: "Need help? You can contact our support team and we will try to answer as soon as possible.",
            iconName: "tray"
        ),
        HelpSupportItem(
            title: "Delete my account",
            description: "You can request to delete your account. This action can remove your profile and personal data from Cleari.",
            iconName: "rectangle.portrait.and.arrow.right"
        ),
        HelpSupportItem(
            title: "Where does my data go?",
            description: "Your data is used to personalize your experience and help dermatologists understand your skin situation better.",
            iconName: "trash"
        ),
        HelpSupportItem(
            title: "How is my data protected?",
            description: "Your personal information is stored securely and only shared when it is needed for the app experience.",
            iconName: "trash"
        ),
        HelpSupportItem(
            title: "How does the skin scan work?",
            description: "The skin scan helps analyze visible skin concerns based on the information and photos you provide.",
            iconName: "trash"
        ),
        HelpSupportItem(
            title: "Is the skin analysis accurate?",
            description: "The analysis can help guide you, but it should not replace advice from a certified dermatologist.",
            iconName: "trash"
        ),
        HelpSupportItem(
            title: "Can the app diagnose skin diseases?",
            description: "No. Cleari can give guidance, but only a medical professional can diagnose skin diseases.",
            iconName: "trash"
        ),
        HelpSupportItem(
            title: "Are dermatologists certified?",
            description: "Dermatologists shown in the app should be verified before offering consultations through Cleari.",
            iconName: "trash"
        )
    ]

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 26) {
                        ForEach(helpItems) { item in
                            HelpSupportRow(
                                item: item,
                                isOpen: openedItemId == item.id
                            ) {
                                if openedItemId == item.id {
                                    openedItemId = nil
                                } else {
                                    openedItemId = item.id
                                }
                            }
                        }
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 34)
            .padding(.top, 95)
        }
    }
}

extension HelpSupportView {
    private var header: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 34, weight: .regular))
                        .foregroundColor(.white)
                }

                Spacer()
            }

            Text("Support")
                .font(AppFont.gillSwiftUI(.bold, size: 40))
                .foregroundColor(Color(hex: "1A1018"))
        }
    }
}
