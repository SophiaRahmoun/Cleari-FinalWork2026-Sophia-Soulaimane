//
//  UserRegisterView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

struct UserRegisterView: View {
    var onSuccess: () -> Void = {}
    var onBack: () -> Void = {}
    
    
    @StateObject private var viewModel = AuthViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var birthdate = Date()
    
    var body: some View {
        ZStack {
            RadialGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()
            ScrollView(showsIndicators: false) {

                          VStack(spacing: 18) {

                              HStack {

                                  Button {

                                      onBack()

                                  } label: {

                                      Image(systemName: "chevron.left")

                                          .font(.system(size: 22, weight: .bold))

                                          .foregroundColor(.white)

                                          .padding(12)

                                  }

                                  Spacer()

                              }

                              .padding(.top, 20)

                              TypographyLabel(

                                  text: "Create your account",

                                  style: .h1Italic,

                                  color: .black

                              )

                              .padding(.top, 5)

                              VStack(spacing: 16) {

                                  AuthRegisterInput(label: "First Name", text: $firstName, maxLength: 20)

                                  AuthRegisterInput(label: "Surname", text: $lastName, maxLength: 20)

                                  AuthRegisterInput(label: "Email", text: $email, maxLength: 20)

                                  AuthRegisterInput(label: "Password", text: $password, maxLength: 25, isSecure: true)

                                  AuthBirthdatePicker(birthdate: $birthdate)

                              }

                              .padding(.horizontal, 8)

                              PrimaryButton(title: viewModel.isLoading ? "LOADING..." : "NEXT STEP") {
                                  Task {
                                      await viewModel.registerUser(
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          password: password
                                      )
                                  }
                              }

                              .padding(.horizontal, 60)

                              .padding(.top, 8)

                             
                             

                              AuthBottomLink(
                                  text: "Already have an account?",

                                  linkText: "Sign in"

                              )

                              .frame(maxWidth: .infinity, alignment: .leading)

                              .padding(.top, 8)

                              Spacer(minLength: 30)

                          }

                          .padding(.horizontal, 32)

                      }
            .onChange(of: viewModel.isLoggedIn) { _, isLoggedIn in
                if isLoggedIn {
                    print("REGISTER SUCCESS → GO TO SCAN")
                    onSuccess()
                }
            }

                  }

              }
          }

#Preview {
    UserRegisterView()
}
