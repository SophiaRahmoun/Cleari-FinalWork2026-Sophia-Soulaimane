//
//  AppointmentModels.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import Foundation

struct AppointmentResponse: Codable {
    let message: String?
    let appointment: Appointment
}

struct AppointmentsListResponse: Codable {
    let appointments: [Appointment]
}

struct Appointment: Identifiable, Codable {
    let id: Int
    let userId: Int
    let dermatologistProfileId: Int
    let appointmentDate: String
    let appointmentTime: String
    let reason: String?
    let status: String
    let createdAt: String?
    let updatedAt: String?

    let user: AppointmentUser?
    let dermatologistProfile: AppointmentDermatologistProfile?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case dermatologistProfileId = "dermatologist_profile_id"
        case appointmentDate = "appointment_date"
        case appointmentTime = "appointment_time"
        case reason
        case status
        case createdAt
        case updatedAt
        case user
        case dermatologistProfile
    }
}

struct AppointmentUser: Codable {
    let id: Int
    let username: String
    let email: String
    let profilePictureUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case profilePictureUrl = "profile_picture_url"
    }
}

struct AppointmentDermatologistProfile: Codable {
    let id: Int
    let userId: Int?
    let user: AppointmentUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case user
    }
}

struct CreateAppointmentRequest: Codable {
    let dermatologist_profile_id: Int
    let appointment_date: String
    let appointment_time: String
    let reason: String?
}

struct UpdateAppointmentStatusRequest: Codable {
    let status: String
}
