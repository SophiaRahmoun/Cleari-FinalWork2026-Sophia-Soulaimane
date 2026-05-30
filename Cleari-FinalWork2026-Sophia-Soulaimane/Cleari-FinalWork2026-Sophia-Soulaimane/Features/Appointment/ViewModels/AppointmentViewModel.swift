//
//  AppointmentViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import Foundation

@MainActor
final class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var requests: [Appointment] = []

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    func createAppointment(
        dermatologistProfileId: Int,
        appointmentDate: String,
        appointmentTime: String = "10:00",
        reason: String? = nil
    ) async -> Bool {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            _ = try await AppointmentService.shared.createAppointment(
                dermatologistProfileId: dermatologistProfileId,
                appointmentDate: appointmentDate,
                appointmentTime: appointmentTime,
                reason: reason
            )

            successMessage = "Appointment request created successfully."
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    func fetchMyAppointments() async {
        isLoading = true
        errorMessage = nil

        do {
            appointments = try await AppointmentService.shared.getMyAppointments()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func fetchDermatologistRequests() async {
        isLoading = true
        errorMessage = nil

        do {
            requests = try await AppointmentService.shared.getDermatologistRequests()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func acceptRequest(_ appointment: Appointment) async {
        await updateStatus(appointment, status: "confirmed")
    }

    func declineRequest(_ appointment: Appointment) async {
        await updateStatus(appointment, status: "cancelled")
    }

    private func updateStatus(_ appointment: Appointment, status: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let updated = try await AppointmentService.shared.updateAppointmentStatus(
                appointmentId: appointment.id,
                status: status
            )

            if let index = requests.firstIndex(where: { $0.id == appointment.id }) {
                requests[index] = updated
            }

            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
