//
//  DermatologistRegisterView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

private let professionOptions: [String] = [
    "Dermatologist",
    "General Practitioner",
    "Pediatric Dermatologist",
    "Cosmetic Dermatologist",
    "Venereologist"
]

private let conventionOptions: [(label: String, value: String)] = [
    ("Conventioned", "conventioned"),
    ("Partially conventioned", "partially_conventioned"),
    ("Not conventioned", "not_conventioned")
]

struct DermatologistRegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    var onSuccess: () -> Void = {}

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedProfession = professionOptions[0]
    @State private var selectedConvention = conventionOptions[0].value
    @State private var inamiNumber = ""

    private var generatedUsername: String {
        let base = "\(firstName.lowercased()).\(lastName.lowercased())"
            .replacingOccurrences(of: " ", with: "")
        return base.isEmpty ? "" : base
    }

    var body: some View {
        ZStack {
            RadialGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer(minLength: 20)

                    Text("Create your account")
                        .font(AppFont.gillSwiftUI(.italic, size: 28))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)

                    AuthRegisterInput(label: "First name", text: $firstName, maxLength: 50)
                    AuthRegisterInput(label: "Last name", text: $lastName, maxLength: 50)

                    // Username preview (auto-generated, read-only)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Username")
                            .font(AppFont.gillSwiftUI(.regular, size: 13))
                            .foregroundColor(.black.opacity(0.55))
                            .padding(.leading, 20)
                        HStack {
                            Text(generatedUsername.isEmpty ? "Generated from first & last name" : generatedUsername)
                                .font(AppFont.gillSwiftUI(.regular, size: 18))
                                .foregroundColor(generatedUsername.isEmpty ? .black.opacity(0.35) : .black)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 65)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "E6DED6").opacity(0.6))
                                .shadow(color: .black.opacity(0.05), radius: 4, y: 3)
                        )
                    }

                    AuthRegisterInput(label: "Email", text: $email, maxLength: 100)
                    AuthRegisterInput(label: "Password", text: $password, maxLength: 100, isSecure: true)

                    // Profession picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Profession")
                            .font(AppFont.gillSwiftUI(.regular, size: 13))
                            .foregroundColor(.black.opacity(0.55))
                            .padding(.leading, 20)
                        Menu {
                            ForEach(professionOptions, id: \.self) { option in
                                Button(option) { selectedProfession = option }
                            }
                        } label: {
                            HStack {
                                Text(selectedProfession)
                                    .font(AppFont.gillSwiftUI(.regular, size: 18))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.5))
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 65)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(hex: "E6DED6"))
                                    .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
                            )
                        }
                    }

                    // Convention status picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Convention status")
                            .font(AppFont.gillSwiftUI(.regular, size: 13))
                            .foregroundColor(.black.opacity(0.55))
                            .padding(.leading, 20)
                        Menu {
                            ForEach(conventionOptions, id: \.value) { option in
                                Button(option.label) { selectedConvention = option.value }
                            }
                        } label: {
                            HStack {
                                Text(conventionOptions.first(where: { $0.value == selectedConvention })?.label ?? "")
                                    .font(AppFont.gillSwiftUI(.regular, size: 18))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.5))
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 65)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(hex: "E6DED6"))
                                    .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
                            )
                        }
                    }

                    AuthRegisterInput(label: "INAMI number", text: $inamiNumber, maxLength: 20)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(AppFont.gillSwiftUI(.regular, size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                    }

                    PrimaryButton(title: viewModel.isLoading ? "LOADING..." : "REGISTER") {
                        Task {
                            await viewModel.registerDermatologist(
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                password: password,
                                specialization: selectedProfession,
                                conventionStatus: selectedConvention,
                                inamiNumber: inamiNumber.isEmpty ? nil : inamiNumber
                            )
                            if viewModel.isLoggedIn {
                                onSuccess()
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 10)

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
