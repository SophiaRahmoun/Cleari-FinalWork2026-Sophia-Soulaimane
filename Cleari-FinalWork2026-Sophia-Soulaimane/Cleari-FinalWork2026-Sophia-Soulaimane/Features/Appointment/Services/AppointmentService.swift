//
//  AppointmentService.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import Foundation

final class AppointmentService {
    static let shared = AppointmentService()

    private init() {}

    private let baseURL = "\(APIConfig.baseURL)/appointments"

    private func makeRequest(
        endpoint: String = "",
        method: String,
        body: Encodable? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        return request
    }

    func createAppointment(
        dermatologistProfileId: Int,
        appointmentDate: String,
        appointmentTime: String,
        reason: String?
    ) async throws -> Appointment {
        let body = CreateAppointmentRequest(
            dermatologist_profile_id: dermatologistProfileId,
            appointment_date: appointmentDate,
            appointment_time: appointmentTime,
            reason: reason
        )

        let request = try makeRequest(method: "POST", body: body)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AppointmentResponse.self, from: data)

        return response.appointment
    }

    func getMyAppointments() async throws -> [Appointment] {
        let request = try makeRequest(endpoint: "/me", method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AppointmentsListResponse.self, from: data)

        return response.appointments
    }

    func getDermatologistRequests() async throws -> [Appointment] {
        let request = try makeRequest(endpoint: "/dermatologist/requests", method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AppointmentsListResponse.self, from: data)

        return response.appointments
    }

    func updateAppointmentStatus(
        appointmentId: Int,
        status: String
    ) async throws -> Appointment {
        let body = UpdateAppointmentStatusRequest(status: status)

        let request = try makeRequest(
            endpoint: "/\(appointmentId)/status",
            method: "PATCH",
            body: body
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AppointmentResponse.self, from: data)

        return response.appointment
    }

    func cancelMyAppointment(appointmentId: Int) async throws -> Appointment {
        let request = try makeRequest(
            endpoint: "/\(appointmentId)/cancel",
            method: "PATCH"
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AppointmentResponse.self, from: data)

        return response.appointment
    }
}

struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self.encodeFunc = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
