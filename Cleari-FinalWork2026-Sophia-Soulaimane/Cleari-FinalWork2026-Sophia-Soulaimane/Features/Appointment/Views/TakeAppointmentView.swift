//
//  TakeAppointmentView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 28/05/2026.
//

import SwiftUI

struct TakeAppointmentView: View {
    let dermatologistName: String
    let dermatologistProfileId: Int

    @Environment(\.dismiss) private var dismiss

    @State private var displayedMonth = Date()
    @State private var selectedDate: Date?
    @State private var showThankYouPopup = false

    private let calendar = Calendar.current

    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "FFFFFF", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(spacing: 40) {
                header

                Spacer().frame(height: 40)

                dermatologistInfo

                AppointmentCalendarCard(
                    displayedMonth: displayedMonth,
                    selectedDate: selectedDate,
                    calendarDays: calendarDays,
                    monthTitle: monthTitle,
                    onPreviousMonth: {
                        changeMonth(by: -1)
                    },
                    onNextMonth: {
                        changeMonth(by: 1)
                    },
                    onSelectDate: { date in
                        selectedDate = date
                        showThankYouPopup = true
                    }
                )

                Spacer()
            }
            .padding(.horizontal, 28)

            if showThankYouPopup {
                AppointmentThankYouPopup(
                    dermatologistName: dermatologistName
                ) {
                    showThankYouPopup = false
                    dismiss()
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            TypographyLabel(
                text: "Take an appointment",
                style: .h2,
                color: .black
            )

            Spacer()
        }
        .padding(.top, 45)
    }

    private var dermatologistInfo: some View {
        VStack(spacing: 2) {
            TypographyLabel(
                text: "Dr. \(dermatologistName)",
                style: .h2,
                color: .black,
                alignment: .center
            )

            TypographyLabel(
                text: "Dermatologist",
                style: .caption,
                color: .black.opacity(0.75),
                alignment: .center
            )
        }
    }

    private var monthTitle: String {
        displayedMonth.formatted(.dateTime.month(.abbreviated).year())
    }

    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth) else {
            return []
        }

        let firstDayOfMonth = monthInterval.start
        let numberOfDays = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 0
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let leadingEmptyDays = weekday - 1

        var days: [Date] = []

        if leadingEmptyDays > 0 {
            for i in stride(from: leadingEmptyDays, through: 1, by: -1) {
                if let date = calendar.date(byAdding: .day, value: -i, to: firstDayOfMonth) {
                    days.append(date)
                }
            }
        }

        for day in 0..<numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth) {
                days.append(date)
            }
        }

        while days.count % 7 != 0 {
            if let last = days.last,
               let next = calendar.date(byAdding: .day, value: 1, to: last) {
                days.append(next)
            } else {
                break
            }
        }

        return days
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
            selectedDate = nil
        }
    }
}

#Preview {
    TakeAppointmentView(
        dermatologistName: "Sarah Ben Ali",
        dermatologistProfileId: 1
    )
}
