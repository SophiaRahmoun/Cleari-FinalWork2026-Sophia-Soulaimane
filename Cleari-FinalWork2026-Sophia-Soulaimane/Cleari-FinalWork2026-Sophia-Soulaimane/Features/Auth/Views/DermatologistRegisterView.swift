//
//  DermatologistRegisterView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct DermatologistRegisterView: View {

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    @State private var selectedMonth = ""
    @State private var selectedDay = ""
    @State private var selectedYear = ""

    var body: some View {
        ZStack {

            // BACKGROUND
            RadialGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    Spacer(minLength: 20)

                    // Title
                    Text("Create your account")
                        .font(AppFont.gillSwiftUI(.italic, size: 28))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Input
                    AuthRegisterInput(
                        label: "Voornaam",
                        text: $firstName,
                        maxLength: 50
                    )

                    AuthRegisterInput(
                        label: "Achternaam",
                        text: $lastName,
                        maxLength: 50
                    )

                    AuthRegisterInput(
                        label: "Email",
                        text: $email,
                        maxLength: 50
                    )

                    AuthRegisterInput(
                        label: "Password",
                        text: $password,
                        maxLength: 50
                    )

                    // Birthdate
                    AuthBirthdatePicker(
                        selectedMonth: $selectedMonth,
                        selectedDay: $selectedDay,
                        selectedYear: $selectedYear
                    )

                    // Document upload
                    AuthDocumentUploadBox {
                        print("Upload attest tapped")
                    }

                    // Button
                    PrimaryButton(title: "NEXT STEP") {
                        print("Dermatologist register tapped")
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 10)

                    // Bottomlink
                    AuthBottomLink(
                        text: "Already have an account?",
                        linkText: "Sign in"
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 18)

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DermatologistRegisterView()
}
