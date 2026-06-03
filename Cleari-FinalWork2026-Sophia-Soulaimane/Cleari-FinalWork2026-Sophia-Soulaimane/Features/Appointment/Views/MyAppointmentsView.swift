//
//  MyAppointmentsView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/05/2026.
//

import SwiftUI

struct MyAppointmentsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AppointmentViewModel
    @State private var showScan = false
    @State private var showFindDermatologist = false
       init(previewAppointments: [Appointment] = []) {
           _viewModel = StateObject(
               wrappedValue: AppointmentViewModel(
                   appointments: previewAppointments
               )
           )
       }

    var body: some View {
        ZStack {
            LinearGradientBackground(
                startHex: "FFFFFF",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    TypographyLabel(text: "Appointments", style: .h1, color: .black)
                        .padding(.top, 60)
                    content.padding(.top, 95)
                    previousSection.padding(.top, 85)
                    Spacer()
                }
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.bottom, 40)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ScanBottomBar(
                    onHomeTapped: { dismiss() },
                    onFindDermatologistTapped: { showFindDermatologist = true },
                    onScanTapped: { showScan = true },
                    onCalendarTapped: nil,
                    activeTab: 3
                )
                .padding(.bottom, 8)
            }
        }
        .task {
            if viewModel.appointments.isEmpty {
                await viewModel.fetchMyAppointments()
            }
        }
        .fullScreenCover(isPresented: $showScan) { CameraCaptureView() }
        .fullScreenCover(isPresented: $showFindDermatologist) { FindDermatologistView() }
    }

    private var header: some View {
        TypographyLabel(text: "Appointments", style: .h1, color: .black)
    }

    private var content: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if let appointment = currentAppointment {
                VStack(alignment: .leading, spacing: 18) {
                    AppointmentStatusStepper(status: appointment.status)

                    TypographyLabel(
                        text: statusTitle(for: appointment.status),
                        style: .h2,
                        color: .black
                    )

                    TypographyLabel(
                        text: statusMessage(for: appointment.status),
                        style: .body,
                        color: .black
                    )

                    currentAppointmentCard(appointment)
                        .padding(.top, 18)
                }
            } else {
                AppointmentEmptyMessage(
                    title: "No upcoming appointment",
                    message: "You currently have no appointment waiting for a dermatologist response."
                )
            }
        }
    }

    private var previousSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            TypographyLabel(
                text: "Previous appointments",
                style: .h2,
                color: .black
            )

            if previousAppointments.isEmpty {
                AppointmentEmptyMessage(
                    title: "No previous appointments",
                    message: "Your past appointments will appear here once they are completed or cancelled."
                )
            } else {
                VStack(spacing: 16) {
                    ForEach(previousAppointments) { appointment in
                        previousAppointmentRow(appointment)
                    }
                }
            }
        }
    }

    private func currentAppointmentCard(_ appointment: Appointment) -> some View {
        HStack(spacing: 20) {
            Circle()
                .fill(Color.white.opacity(0.35))
                .frame(width: 76, height: 76)

            VStack(alignment: .leading, spacing: 6) {
                TypographyLabel(
                    text: "Dr. \(appointment.dermatologistProfile?.user?.username ?? "Dermatologist")",
                    style: .body,
                    color: .white
                )

                TypographyLabel(
                    text: "\(formatDate(appointment.appointmentDate)) • \(appointment.appointmentTime)",
                    style: .caption,
                    color: .white.opacity(0.8)
                )
            }

            Spacer()

            Text(statusBadgeText(for: appointment.status))
                .font(AppFont.gillSwiftUI(.regular, size: 12))
                .foregroundColor(Color(hex: "1E141D"))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.85))
                .clipShape(Capsule())
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "1E141D").opacity(0.95))
        .cornerRadius(18)
    }

    private func previousAppointmentRow(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            TypographyLabel(
                text: formatDate(appointment.appointmentDate),
                style: .body,
                color: .black
            )

            TypographyLabel(
                text: "Dr. \(appointment.dermatologistProfile?.user?.username ?? "Dermatologist")",
                style: .caption,
                color: .black.opacity(0.7)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var currentAppointment: Appointment? {
        viewModel.appointments.first {
            $0.status == "pending" || $0.status == "confirmed"
        }
    }

    private var previousAppointments: [Appointment] {
        viewModel.appointments.filter {
            $0.status == "completed" || $0.status == "cancelled"
        }
    }

    private func statusTitle(for status: String) -> String {
        switch status {
        case "pending":
            return "Awaiting response"
        case "confirmed":
            return "Appointment confirmed"
        case "cancelled":
            return "Appointment declined"
        case "completed":
            return "Appointment completed"
        default:
            return "Appointment status"
        }
    }

    private func statusMessage(for status: String) -> String {
        switch status {
        case "pending":
            return "Your request has been sent. We will keep you informed as soon as the dermatologist responds."
        case "confirmed":
            return "Your appointment has been accepted by the dermatologist."
        case "cancelled":
            return "This appointment request has been declined or cancelled."
        case "completed":
            return "This appointment has been completed."
        default:
            return ""
        }
    }

    private func statusBadgeText(for status: String) -> String {
        switch status {
        case "pending":
            return "Processing..."
        case "confirmed":
            return "Confirmed"
        case "cancelled":
            return "Cancelled"
        case "completed":
            return "Completed"
        default:
            return status
        }
    }

    private func formatDate(_ value: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"

        let output = DateFormatter()
        output.dateFormat = "d MMMM yyyy"

        guard let date = input.date(from: value) else {
            return value
        }

        return output.string(from: date)
    }
}

#Preview {
    MyAppointmentsView(
            previewAppointments: [
                Appointment(
                    id: 1,
                    userId: 1,
                    dermatologistProfileId: 1,
                    appointmentDate: "2026-08-07",
                    appointmentTime: "10:00",
                    reason: nil,
                    status: "pending",
                    createdAt: nil,
                    updatedAt: nil,
                    user: nil,
                    dermatologistProfile: AppointmentDermatologistProfile(
                        id: 1,
                        userId: 2,
                        user: AppointmentUser(
                            id: 2,
                            username: "Sarah Ben Ali",
                            email: "sarah@example.com",
                            profilePictureUrl: nil
                        )
                    )
                ),
                Appointment(
                    id: 2,
                    userId: 1,
                    dermatologistProfileId: 2,
                    appointmentDate: "2025-08-09",
                    appointmentTime: "14:00",
                    reason: nil,
                    status: "completed",
                    createdAt: nil,
                    updatedAt: nil,
                    user: nil,
                    dermatologistProfile: AppointmentDermatologistProfile(
                        id: 2,
                        userId: 3,
                        user: AppointmentUser(
                            id: 3,
                            username: "Halioui Said",
                            email: "halioui@example.com",
                            profilePictureUrl: nil
                        )
                    )
                )
            ]
        )
    }
