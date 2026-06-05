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
        currentUser?.role == "dermatologist" && currentUser?.dermatologistProfile?.verificationStatus == "pending"
    }

    var isApprovedDermatologist: Bool {
        currentUser?.role == "dermatologist" && currentUser?.dermatologistProfile?.verificationStatus == "approved"
    }
    
    // Called on app launch when a token already exists in storage.
    // Returns the AppRoute to navigate to, or nil if token is invalid.
    func validateSession() async -> AppRoute? {
        guard TokenStorage.shared.token != nil else { return nil }

        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await AuthAPIService.shared.fetchMe()
            currentUser = user
            isLoggedIn = true

            TokenStorage.shared.userRole = user.role
            TokenStorage.shared.userId = user.id
            TokenStorage.shared.hasCompletedSkinForm = user.hasCompletedSkinForm

            if user.role == "dermatologist" {
                TokenStorage.shared.dermVerificationStatus = user.dermatologistProfile?.verificationStatus
                let status = user.dermatologistProfile?.verificationStatus ?? "pending"
                return status == "approved" ? .userHome : .dermPending
            } else {
                return user.hasCompletedSkinForm ? .userHome : .consultationForm
            }
        } catch {
            // Only revoke the token for genuine auth failures (401/403).
            // Network errors (timeout, server sleeping) must NOT clear the token —
            // the user should stay logged in and we fall back to cached data.
            let code = (error as NSError).code
            let isAuthError = code == 401 || code == 403

            if isAuthError {
                TokenStorage.shared.clear()
                isLoggedIn = false
                currentUser = nil
                return nil
            }

            // Network/server error: navigate using cached TokenStorage values
            isLoggedIn = true
            let role = TokenStorage.shared.userRole ?? ""
            if role == "dermatologist" {
                let status = TokenStorage.shared.dermVerificationStatus ?? "pending"
                return status == "approved" ? .userHome : .dermPending
            } else {
                return TokenStorage.shared.hasCompletedSkinForm ? .userHome : .consultationForm
            }
        }
    }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await AuthAPIService.shared.login(
                email: email,
                password: password
            )

            TokenStorage.shared.token = response.token
            TokenStorage.shared.userRole = response.user.role
            TokenStorage.shared.userId = response.user.id
            TokenStorage.shared.dermVerificationStatus = response.user.dermatologistProfile?.verificationStatus
            TokenStorage.shared.hasCompletedSkinForm = response.user.hasCompletedSkinForm

            currentUser = response.user
            isLoggedIn = true

            print("LOGIN SUCCESS:", response.user.email)
        } catch {
            isLoggedIn = false
            currentUser = nil
            errorMessage = cleanError(error.localizedDescription)
        }
    }

    func registerUser(
        firstName: String,
        lastName: String,
        username: String,
        email: String,
        password: String
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await AuthAPIService.shared.registerUser(
                firstName: firstName,
                lastName: lastName,
                username: username,
                email: email,
                password: password
            )

            TokenStorage.shared.token = response.token
            TokenStorage.shared.userRole = response.user.role
            TokenStorage.shared.userId = response.user.id
            TokenStorage.shared.hasCompletedSkinForm = false

            currentUser = response.user
            isLoggedIn = true

            print("USER REGISTER SUCCESS:", response.user.email)
        } catch {
            isLoggedIn = false
            currentUser = nil
            errorMessage = cleanError(error.localizedDescription)
        }
    }

    func registerDermatologist(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        specialization: String?,
        conventionStatus: String?,
        inamiNumber: String?
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let base = "\(firstName.lowercased()).\(lastName.lowercased())"
                .replacingOccurrences(of: " ", with: "")
            let username = base.isEmpty ? email : base

            let response = try await AuthAPIService.shared.registerDermatologist(
                firstName: firstName,
                lastName: lastName,
                username: username,
                email: email,
                password: password,
                specialization: specialization,
                conventionStatus: conventionStatus,
                inamiNumber: inamiNumber
            )

            TokenStorage.shared.token = response.token
            TokenStorage.shared.userRole = response.user.role
            TokenStorage.shared.userId = response.user.id

            currentUser = response.user
            isLoggedIn = true

            TokenStorage.shared.dermVerificationStatus = response.user.dermatologistProfile?.verificationStatus ?? "pending"

            print("DERMATOLOGIST REGISTER SUCCESS:", response.user.email)
        } catch {
            isLoggedIn = false
            currentUser = nil
            errorMessage = cleanError(error.localizedDescription)
        }
    }

    func logout() {
        TokenStorage.shared.clear()
        currentUser = nil
        isLoggedIn = false
        errorMessage = nil
    }

    private func cleanError(_ message: String) -> String {
        message
            .replacingOccurrences(of: "{\"message\":\"", with: "")
            .replacingOccurrences(of: "\"}", with: "")
    }
}
