//
//  BookAppointmentFromChatView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Lets a user request an appointment with the dermatologist of a conversation.
//

import SwiftUI

struct BookAppointmentFromChatView: View {
    let conversationId: Int
    let dermatologistName: String

    @Environment(\.dismiss) private var dismiss

    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var reason = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var didSucceed = false

    private let dark = Color(hex: "1A1018")
    private let pink = Color(hex: "C66F8C")

    var body: some View {
        NavigationStack {
            ZStack {
                BeigeBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("Request an appointment")
                            .font(AppFont.gillSwiftUI(.bold, size: 24))
                            .foregroundColor(dark)

                        Text("With \(dermatologistName)")
                            .font(AppFont.gillSwiftUI(.regular, size: 15))
                            .foregroundColor(dark.opacity(0.6))

                        // Calendar
                        DatePicker(
                            "Date",
                            selection: $selectedDate,
                            in: Date()...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .tint(pink)
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // Time
                        HStack {
                            Text("Time")
                                .font(AppFont.gillSwiftUI(.regular, size: 16))
                                .foregroundColor(dark)
                            Spacer()
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .tint(pink)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // Reason
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reason")
                                .font(AppFont.gillSwiftUI(.regular, size: 16))
                                .foregroundColor(dark)
                            TextField("Describe your concern…", text: $reason, axis: .vertical)
                                .font(AppFont.gillSwiftUI(.regular, size: 15))
                                .lineLimit(3...6)
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        if let errorMessage {
                            Text(errorMessage)
                                .font(AppFont.gillSwiftUI(.regular, size: 14))
                                .foregroundColor(.red)
                        }

                        Button {
                            Task { await submit() }
                        } label: {
                            HStack {
                                if isSubmitting { ProgressView().tint(.white) }
                                Text(isSubmitting ? "Sending…" : "Send request")
                                    .font(AppFont.gillSwiftUI(.bold, size: 17))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(pink)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(isSubmitting)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").foregroundColor(dark)
                    }
                }
            }
            .alert("Request sent", isPresented: $didSucceed) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your appointment request was sent to \(dermatologistName).")
            }
        }
    }

    private func submit() async {
        isSubmitting = true
        errorMessage = nil

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let timeFmt = DateFormatter()
        timeFmt.dateFormat = "HH:mm"

        do {
            try await ChatService.shared.bookAppointment(
                conversationId: conversationId,
                date: dateFmt.string(from: selectedDate),
                time: timeFmt.string(from: selectedTime),
                reason: reason.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            didSucceed = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isSubmitting = false
    }
}
