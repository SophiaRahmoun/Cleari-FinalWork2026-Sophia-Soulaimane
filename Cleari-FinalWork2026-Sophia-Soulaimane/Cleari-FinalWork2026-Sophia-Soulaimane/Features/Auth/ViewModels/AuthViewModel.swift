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
    
    func login (email: String, password: String) async{
        isLoading = true
        errorMessage = nil
        
        do {
            let response: AuthResponse = try await post(
                endpoint: "/auth/login",
                body: LoginRequest(email: email, password: password)
            )
            
            TokenStorage.shared.token = response.token
            currentUser = response.user
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func registerUser(firstName: String, lastName: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
                
        do {
            print("REGISTER REQUEST SENT")
            let response: AuthResponse = try await post(
                endpoint: "/auth/register-user",
                body: RegisterUserRequest(
                    username: "\(firstName) \(lastName)",
                    email: email,
                    password: password
                )
            )
            print("REGISTER RESPONSE RECEIVED:", response)
            
            TokenStorage.shared.token = response.token
            currentUser = response.user
            isLoggedIn = true
            print("IS LOGGED IN SET TO TRUE")
        } catch {
                  errorMessage = error.localizedDescription
              }
              isLoading = false
          }
    
    func registerDermatologist(firstName: String, lastName: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: AuthResponse = try await post(
                           endpoint: "/auth/register-dermatologist",
                           body: RegisterDermatologistRequest(
                               username: "\(firstName) \(lastName)",
                               email: email,
                               password: password,
                               specialization: "Dermatology",
                               license_number: nil,
                               bio: nil
                           )
                       )

                       TokenStorage.shared.token = response.token
                       currentUser = response.user
                       isLoggedIn = true

                   } catch {

                       errorMessage = error.localizedDescription

                   }

                   isLoading = false
    }

          private func post<T: Codable, U: Codable>(endpoint: String, body: T) async throws -> U {
              guard let url = URL(string: APIConfig.baseURL + endpoint) else {
                  throw URLError(.badURL)
              }

              var request = URLRequest(url: url)
              request.httpMethod = "POST"
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              request.httpBody = try JSONEncoder().encode(body)
              
              let (data, response) = try await URLSession.shared.data(for: request)
              
              guard let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode else {
                  let backendError = String(data: data, encoding: .utf8) ?? "Unknown error"
                  throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: backendError])
              }
              return try JSONDecoder().decode(U.self, from: data)
          }
      }
