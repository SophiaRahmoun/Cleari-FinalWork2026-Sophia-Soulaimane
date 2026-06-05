//
//  AppointmentCalendarCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct AppointmentCalendarCard: View {
    let displayedMonth: Date
    let selectedDate: Date?
    let calendarDays: [Date]
    let monthTitle: String
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onSelectDate: (Date) -> Void

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 14) {
            calendarHeader
            weekDays
            daysGrid
        }
        .padding(18)
        .background(Color.white.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.black, lineWidth: 1.5)
        )
        .cornerRadius(14)
    }

    private var calendarHeader: some View {
        HStack {
            Button {
                onPreviousMonth()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }

            Spacer()

            TypographyLabel(
                text: monthTitle,
                style: .body,
                color: .black,
                alignment: .center
            )

            Spacer()

            Button {
                onNextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
        }
    }

    private var weekDays: some View {
        HStack {
            ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                TypographyLabel(
                    text: day,
                    style: .caption,
                    color: .black.opacity(0.5),
                    alignment: .center
                )
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var daysGrid: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(Array(calendarDays.enumerated()), id: \.offset) { _, date in
                AppointmentDayCell(
                    date: date,
                    displayedMonth: displayedMonth,
                    selectedDate: selectedDate
                ) {
                    onSelectDate(date)
                }
            }
        }
    }
}
