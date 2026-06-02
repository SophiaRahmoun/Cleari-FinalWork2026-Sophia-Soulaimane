//
//  DermatologistAppointmentRequestsView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct DermatologistAppointmentRequestsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AppointmentViewModel
    init(previewRequests: [Appointment] = []) {
        
        _viewModel = StateObject(

            wrappedValue: AppointmentViewModel(

                requests: previewRequests

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
            
            VStack(alignment: .leading, spacing: 28) {
                header
                    .padding(.top, 40)
                
                
                
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                } else if viewModel.requests.isEmpty {
                    TypographyLabel(
                        text: "No appointment requests yet.",
                        style: .body,
                        color: .black
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 30) {
                            ForEach(viewModel.requests) { appointment in
                                AppointmentRequestCard(
                                    userName: appointment.user?.username ?? "Unknown user",
                                    appointmentDate: formatDate(appointment.appointmentDate),
                                    timeAgo: timeAgo(from: appointment.createdAt),
                                    profileImageUrl: appointment.user?.profilePictureUrl ?? "",
                                    onAccept: {
                                        Task {
                                            await viewModel.acceptRequest(appointment)
                                        }
                                    },
                                    onDecline: {
                                        Task {
                                            await viewModel.declineRequest(appointment)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .padding(.horizontal, 28)
        
        }
        .task {
            if viewModel.requests.isEmpty {
                await viewModel.fetchDermatologistRequests()
            }
        }
    }
    
    private var content: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
            } else if viewModel.requests.isEmpty {
                TypographyLabel(
                    text: "No appointment requests yet.",
                    style: .body,
                    color: .black
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 80)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        ForEach(viewModel.requests) { appointment in
                            AppointmentRequestCard(
                                userName: appointment.user?.username ?? "Unknown user",
                                appointmentDate: formatDate(appointment.appointmentDate),
                                timeAgo: timeAgo(from: appointment.createdAt),
                                profileImageUrl: appointment.user?.profilePictureUrl ?? "",
                                onAccept: {
                                    Task {
                                        await viewModel.acceptRequest(appointment)
                                    }
                                },
                                onDecline: {
                                    Task {
                                        await viewModel.declineRequest(appointment)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: 18) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            TypographyLabel(
                text: "Appointments",
                style: .h1,
                color: .black
            )

            Spacer()
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

    private func timeAgo(from value: String?) -> String {
        guard let value else { return "" }

        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: value) else {
            return ""
        }

        let seconds = Int(Date().timeIntervalSince(date))

        if seconds < 3600 {
            return "\(max(seconds / 60, 1)) min ago"
        } else if seconds < 86400 {
            return "\(seconds / 3600)h ago"
        } else {
            return "\(seconds / 86400)d ago"
        }
    }
}

#Preview {
    DermatologistAppointmentRequestsView(
            previewRequests: [
                Appointment(
                    id: 1,
                    userId: 4,
                    dermatologistProfileId: 1,
                    appointmentDate: "2026-08-07",
                    appointmentTime: "10:00",
                    reason: "Skin irritation after using a new product.",
                    status: "pending",
                    createdAt: "2026-05-30T17:55:00.000Z",
                    updatedAt: nil,
                    user: AppointmentUser(
                        id: 4,
                        username: "Yser",
                        email: "yser@example.com",
                        profilePictureUrl: nil
                    ),
                    dermatologistProfile: nil
                ),
                Appointment(
                    id: 2,
                    userId: 5,
                    dermatologistProfileId: 1,
                    appointmentDate: "2026-03-06",
                    appointmentTime: "14:00",
                    reason: "Acne consultation.",
                    status: "pending",
                    createdAt: "2026-05-30T17:42:00.000Z",
                    updatedAt: nil,
                    user: AppointmentUser(
                        id: 5,
                        username: "Jason",
                        email: "jason@example.com",
                        profilePictureUrl: nil
                    ),
                    dermatologistProfile: nil
                )
            ]
        )
    }
