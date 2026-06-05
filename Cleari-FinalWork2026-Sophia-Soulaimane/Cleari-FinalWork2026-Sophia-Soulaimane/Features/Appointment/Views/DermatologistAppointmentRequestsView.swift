//
//  DermatologistAppointmentRequestsView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

struct DermatologistAppointmentRequestsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AppointmentViewModel
    @State private var selectedTab = 0              // 0 = Requests, 1 = Calendar
    @State private var selectedAppointment: Appointment? = nil
    @State private var calendarMonth = Date()

    init(previewRequests: [Appointment] = []) {
        _viewModel = StateObject(wrappedValue: AppointmentViewModel(requests: previewRequests))
    }

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "FFFFFF", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header.padding(.top, 40)

                // Tab picker
                Picker("", selection: $selectedTab) {
                    Text("Requests").tag(0)
                    Text("Calendar").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 28)
                .padding(.vertical, 18)

                if selectedTab == 0 {
                    requestsTab
                } else {
                    calendarTab
                }
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .task {
            if viewModel.requests.isEmpty {
                await viewModel.fetchDermatologistRequests()
            }
        }
        .sheet(item: $selectedAppointment) { appointment in
            AppointmentDayDetailSheet(
                appointment: appointment,
                onAccept: {
                    Task {
                        await viewModel.acceptRequest(appointment)
                        selectedAppointment = nil
                    }
                },
                onDecline: {
                    Task {
                        await viewModel.declineRequest(appointment)
                        selectedAppointment = nil
                    }
                }
            )
        }
    }

    // MARK: - Requests tab

    private var requestsTab: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
            } else if viewModel.requests.isEmpty {
                TypographyLabel(text: "No appointment requests yet.", style: .body, color: .black)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        ForEach(viewModel.requests) { appointment in
                            AppointmentRequestCard(
                                userName: appointment.user?.username ?? "Unknown",
                                appointmentDate: formatDate(appointment.appointmentDate),
                                timeAgo: timeAgo(from: appointment.createdAt),
                                profileImageUrl: appointment.user?.profilePictureUrl ?? "",
                                onAccept: { Task { await viewModel.acceptRequest(appointment) } },
                                onDecline: { Task { await viewModel.declineRequest(appointment) } }
                            )
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    // MARK: - Calendar tab

    private var calendarTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Month navigation
                HStack {
                    Button { changeMonth(by: -1) } label: {
                        Image(systemName: "chevron.left").foregroundColor(.black)
                    }
                    Spacer()
                    Text(monthTitle)
                        .font(AppFont.gillSwiftUI(.bold, size: 18))
                        .foregroundColor(.black)
                    Spacer()
                    Button { changeMonth(by: 1) } label: {
                        Image(systemName: "chevron.right").foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 4)

                // Day-of-week headers
                let weekdays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                HStack {
                    ForEach(weekdays, id: \.self) { d in
                        Text(d)
                            .font(AppFont.gillSwiftUI(.regular, size: 12))
                            .foregroundColor(.black.opacity(0.45))
                            .frame(maxWidth: .infinity)
                    }
                }

                // Day grid
                let days = calendarDays
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(0..<days.count, id: \.self) { idx in
                        let day = days[idx]
                        if let day {
                            let dayAppts = appointments(on: day)
                            Button {
                                if let first = dayAppts.first { selectedAppointment = first }
                            } label: {
                                VStack(spacing: 3) {
                                    Text("\(day)")
                                        .font(AppFont.gillSwiftUI(.regular, size: 15))
                                        .foregroundColor(.black)
                                    if !dayAppts.isEmpty {
                                        HStack(spacing: 3) {
                                            ForEach(dayAppts.prefix(3), id: \.id) { a in
                                                Circle()
                                                    .fill(statusColor(a.status))
                                                    .frame(width: 6, height: 6)
                                            }
                                        }
                                    }
                                }
                                .frame(minHeight: 40)
                                .frame(maxWidth: .infinity)
                                .background(dayAppts.isEmpty ? Color.clear : Color.white.opacity(0.45))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        } else {
                            Color.clear.frame(minHeight: 40)
                        }
                    }
                }

                // Legend
                HStack(spacing: 16) {
                    legendDot(Color(hex: "AAAAAA"), "Pending")
                    legendDot(Color(hex: "FF9500"), "Accepted")
                    legendDot(Color(hex: "E05C5C"), "Declined")
                }
                .padding(.top, 8)
            }
            .padding(.top, 10)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 18) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            TypographyLabel(text: "Appointments", style: .h1, color: .black)
            Spacer()
        }
    }

    // MARK: - Helpers

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "approved", "confirmed": return Color(hex: "FF9500") // accepted = orange
        case "declined", "cancelled": return Color(hex: "E05C5C") // declined = red
        default:                       return Color(hex: "AAAAAA") // pending = grey
        }
    }

    private func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(label).font(AppFont.gillSwiftUI(.regular, size: 12)).foregroundColor(.black.opacity(0.6))
        }
    }

    private func appointments(on day: Int) -> [Appointment] {
        let cal = Calendar.current
        return viewModel.requests.filter { appt in
            let parts = appt.appointmentDate.split(separator: "-")
            guard parts.count == 3,
                  let y = Int(parts[0]), let m = Int(parts[1]), let d = Int(parts[2]) else { return false }
            let comps = cal.dateComponents([.year, .month], from: calendarMonth)
            return y == comps.year && m == comps.month && d == day
        }
    }

    private var calendarDays: [Int?] {
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month], from: calendarMonth)
        comps.day = 1
        guard let firstDay = cal.date(from: comps),
              let range = cal.range(of: .day, in: .month, for: firstDay) else { return [] }
        // weekday: 1=Sun, adjust to Mon-start
        var weekday = cal.component(.weekday, from: firstDay) - 2
        if weekday < 0 { weekday += 7 }
        var grid: [Int?] = Array(repeating: nil, count: weekday)
        grid += range.map { Optional($0) }
        while grid.count % 7 != 0 { grid.append(nil) }
        return grid
    }

    private var monthTitle: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: calendarMonth)
    }

    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: calendarMonth) {
            calendarMonth = newDate
        }
    }

    private func formatDate(_ value: String) -> String {
        let input = DateFormatter(); input.dateFormat = "yyyy-MM-dd"
        let output = DateFormatter(); output.dateFormat = "d MMMM yyyy"
        return input.date(from: value).map { output.string(from: $0) } ?? value
    }

    private func timeAgo(from value: String?) -> String {
        guard let value else { return "" }
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: value) else { return "" }
        let s = Int(Date().timeIntervalSince(date))
        if s < 3600 { return "\(max(s / 60, 1)) min ago" }
        if s < 86400 { return "\(s / 3600)h ago" }
        return "\(s / 86400)d ago"
    }
}

// MARK: - Day Detail Sheet

struct AppointmentDayDetailSheet: View {
    let appointment: Appointment
    let onAccept: () -> Void
    let onDecline: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                BeigeBackground()
                VStack(alignment: .leading, spacing: 20) {
                    infoRow("Patient",    appointment.user?.username ?? "Unknown")
                    infoRow("Date",       appointment.appointmentDate)
                    infoRow("Time",       appointment.appointmentTime)
                    if let reason = appointment.reason, !reason.isEmpty {
                        infoRow("Reason", reason)
                    }
                    statusBadge(appointment.status)

                    if appointment.status == "pending" {
                        HStack(spacing: 14) {
                            Button { onDecline() } label: {
                                Text("Decline")
                                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity).frame(height: 50)
                                    .background(Color(hex: "C66F8C"))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            Button { onAccept() } label: {
                                Text("Accept")
                                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity).frame(height: 50)
                                    .background(Color(hex: "3A0616"))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                        .padding(.top, 8)
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)
            }
            .navigationTitle("Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").foregroundColor(Color(hex: "1A1018"))
                    }
                }
            }
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AppFont.gillSwiftUI(.regular, size: 12))
                .foregroundColor(.black.opacity(0.5))
                .textCase(.uppercase)
            Text(value)
                .font(AppFont.gillSwiftUI(.regular, size: 17))
                .foregroundColor(.black)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func statusBadge(_ status: String) -> some View {
        let (color, label): (Color, String) = {
            switch status {
            case "approved", "confirmed": return (Color(hex: "FF9500"), "Accepted")
            case "declined", "cancelled": return (Color(hex: "E05C5C"), "Declined")
            default:                       return (Color(hex: "AAAAAA"), "Pending")
            }
        }()
        return Text(label)
            .font(AppFont.gillSwiftUI(.bold, size: 13))
            .foregroundColor(.white)
            .padding(.horizontal, 14).padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}
