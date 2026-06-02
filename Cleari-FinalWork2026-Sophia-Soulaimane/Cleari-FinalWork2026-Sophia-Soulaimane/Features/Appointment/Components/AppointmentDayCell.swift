//
//  AppointmentDayCell.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct AppointmentDayCell: View {
    let date: Date
    let displayedMonth: Date
    let selectedDate: Date?
    let onTap: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
        let isPast = calendar.startOfDay(for: date) < calendar.startOfDay(for: Date())
        let selected = selectedDate.map { calendar.isDate(date, inSameDayAs: $0) } ?? false

        Button {
            if !isPast {
                onTap()
            }
        } label: {
            Text("\(calendar.component(.day, from: date))")
                .font(AppFont.gillSwiftUI(.regular, size: 14))
                .foregroundColor(isPast ? .black.opacity(0.25) : .black)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(selected ? Color.black.opacity(0.15) : Color.clear)
                )
                .opacity(isCurrentMonth ? 1 : 0.35)
        }
        .disabled(isPast)
    }
}
