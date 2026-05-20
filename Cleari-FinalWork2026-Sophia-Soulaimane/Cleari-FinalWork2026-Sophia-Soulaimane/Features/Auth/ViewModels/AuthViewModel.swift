//
//  AuthViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var currentUser: AuthUser?
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    var isPendingDermatologist: Bool {
           currentUser?.role == "dermatologist" && currentUser?.verificationStatus == "pending"
       }

       var isApprovedDermatologist: Bool {
           currentUser?.role == "dermatologist" && currentUser?.verificationStatus == "approved"
       }
    
    func login(email: String, password: String) async {
           isLoading = true
           errorMessage = nil
           defer { isLoading = false }
           do {
               let response = try await AuthAPIService.shared.login(email: email, password: password)

               TokenStorage.shared.token = response.token
               currentUser = response.user
               isLoggedIn = true
               print("LOGIN SUCCESS:", response.user.email)
           } catch {
               isLoggedIn = false
               currentUser = nil
               errorMessage = cleanError(error.localizedDescription)
           }
       }
       func registerUser(firstName: String, lastName: String, email: String, password: String) async {
           isLoading = true
           errorMessage = nil
           defer { isLoading = false }
           do {
               let username = "\(firstName) \(lastName)"
               let response = try await AuthAPIService.shared.registerUser(username: username, email: email, password: password)
               TokenStorage.shared.token = response.token
               currentUser = response.user
               isLoggedIn = true
               print("USER REGISTER SUCCESS:", response.user.email)
           } catch {
               isLoggedIn = false
               currentUser = nil
               errorMessage = cleanError(error.localizedDescription)
           }
       }

       func registerDermatologist(firstName: String, lastName: String, email: String, password: String, licenseNumber: String? = nil) async {
           isLoading = true
           errorMessage = nil
           defer { isLoading = false }
           do {
               let username = "\(firstName) \(lastName)"
               let response = try await AuthAPIService.shared.registerDermatologist(username: username, email: email, password: password, licenseNumber: licenseNumber)
               TokenStorage.shared.token = response.token
               currentUser = response.user
               isLoggedIn = true
               print("DERMATOLOGIST REGISTER SUCCESS:", response.user.email)
           } catch {
               isLoggedIn = false
               currentUser = nil
               errorMessage = cleanError(error.localizedDescription)
           }
       }

       func logout() {
           TokenStorage.shared.token = nil
           currentUser = nil
           isLoggedIn = false
           errorMessage = nil
       }

       private func cleanError(_ message: String) -> String {
           message.replacingOccurrences(of: "{\"message\":\"", with: "").replacingOccurrences(of: "\"}", with: "")
       }

   }
