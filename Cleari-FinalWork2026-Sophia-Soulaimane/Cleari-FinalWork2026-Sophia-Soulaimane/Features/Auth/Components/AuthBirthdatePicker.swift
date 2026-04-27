//
//  AuthBirthdatePicker.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 27/04/2026.
//

import SwiftUI

struct AuthBirthdatePicker: View {
    @Binding var selectedMonth: String
    @Binding var selectedDay: String
    @Binding var selectedYear: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            TypographyLabel(
                text: "Birthdate",
                style: .button,
                color: .black
            )

            HStack(spacing: 18) {
                dateBox(title: selectedMonth.isEmpty ? "Month" : selectedMonth)
                    .frame(width: 140)

                dateBox(title: selectedDay.isEmpty ? "Day" : selectedDay)
                    .frame(width: 90)

                dateBox(title: selectedYear.isEmpty ? "Year" : selectedYear)
                    .frame(width: 95)
            }
        }
    }

    private func dateBox(title: String) -> some View {
        HStack {
            TypographyLabel(
                text: title,
                style: .button,
                color: .black
            )

            Spacer()

            Image(systemName: "chevron.down")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 14)
        .frame(height: 65)
        .background(Color(hex: "#E6DED6"))
        .cornerRadius(8)
    }
}

#Preview {
    ZStack {
        AuthBackground()

        AuthBirthdatePicker(
            selectedMonth: .constant(""),
            selectedDay: .constant(""),
            selectedYear: .constant("")
        )
        .padding(.horizontal, 32)
    }
}
