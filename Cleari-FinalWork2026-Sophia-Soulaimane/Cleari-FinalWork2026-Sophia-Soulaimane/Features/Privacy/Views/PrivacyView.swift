//
//  PrivacyView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 16/05/2026.
//

import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss

    private let sections: [PrivacySection] = [
        PrivacySection(
            title: "Introduction",
            text: "Cleari is an iOS application that helps users understand their skin better and become more aware of skincare and dermatology. Because users can fill in personal and skin-related information, Cleari values privacy and transparency."
        ),
        PrivacySection(
            title: "What data do we collect?",
            text: "Cleari can collect account data such as name, email address and password. Passwords are processed securely and are not stored visibly. Cleari can also process skin-related information, community posts, reactions, likes and appointment information."
        ),
        PrivacySection(
            title: "Why do we use this data?",
            text: "We use this data to make the main features of the app work correctly. Account data is used for login, skin data is used to personalize the experience, and community data is used to make posts and interactions possible."
        ),
        PrivacySection(
            title: "Where is the data stored?",
            text: "The data collected inside Cleari is stored digitally in a database connected to the application. Only necessary systems and app features have access to this data."
        ),
        PrivacySection(
            title: "Sharing with dermatologists",
            text: "Cleari can allow users to share relevant information with dermatologists, for example for an appointment or skin analysis. This only happens when the user clearly chooses to do so. Cleari does not sell personal data to third parties."
        ),
        PrivacySection(
            title: "Security",
            text: "Cleari takes measures to protect personal data against loss, misuse or unauthorized access. Passwords are processed securely, and the app is checked for technical errors where possible."
        ),
        PrivacySection(
            title: "How long do we keep data?",
            text: "Personal data is only kept as long as needed for the app to function. When a user deletes their account, related personal data is deleted or anonymized where possible."
        ),
        PrivacySection(
            title: "User rights",
            text: "Users have the right to view, change or delete their personal data. They can also ask questions about how their data is processed inside Cleari."
        ),
        PrivacySection(
            title: "Contact",
            text: "For questions about privacy and data processing, users can contact Cleari through the contact information available in the app.\n\nsupport@cleari-app.com\n\nLast updated: May 2026"
        )
    ]

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Here you can read how Cleari handles your personal data and skin-related information.")
                            .font(AppFont.gillSwiftUI(.regular, size: 17))
                            .foregroundColor(Color(hex: "1A1018"))
                            .lineSpacing(5)
                            .padding(.bottom, 10)

                        ForEach(sections) { section in
                            PrivacySectionView(section: section)
                        }
                    }
                    .padding(.top, 55)
                    .padding(.bottom, 45)
                }
            }
            .padding(.horizontal, 34)
            .padding(.top, 95)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension PrivacyView {
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

            Text("Privacy")
                .font(AppFont.gillSwiftUI(.bold, size: 40))
                .foregroundColor(Color(hex: "1A1018"))
        }
    }
}
