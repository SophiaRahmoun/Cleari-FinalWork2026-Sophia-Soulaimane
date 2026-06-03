//
//  PatientRoutinesView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

struct PatientRoutinesView: View {
    let conversationId: Int
    @Environment(\.dismiss) private var dismiss
    @State private var routines: [PatientRoutineRecord] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                BeigeBackground()

                Group {
                    if isLoading {
                        ProgressView().tint(Color(hex: "C66F8C"))
                    } else if routines.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 44))
                                .foregroundColor(Color(hex: "C66F8C").opacity(0.4))
                            Text("This patient hasn't added a routine yet.")
                                .font(AppFont.gillSwiftUI(.regular, size: 16))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 18) {
                                ForEach(routines) { routine in
                                    routineCard(routine)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationTitle("Patient Routine")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").foregroundColor(Color(hex: "1A1018"))
                    }
                }
            }
            .task { await loadRoutines() }
        }
    }

    private func routineCard(_ routine: PatientRoutineRecord) -> some View {
        HStack(spacing: 16) {
            if let url = routine.displayImageUrl {
                AsyncImage(url: url) { phase in
                    if case .success(let img) = phase {
                        img.resizable().scaledToFill()
                    } else {
                        Color(hex: "EDD9C8")
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "EDD9C8"))
                    .frame(width: 64, height: 64)
                    .overlay(Image(systemName: "drop.fill").foregroundColor(Color(hex: "C66F8C").opacity(0.5)))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.productName ?? "Product")
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(.black)
                if let usage = routine.usageTime, !usage.isEmpty {
                    Text(usage)
                        .font(AppFont.gillSwiftUI(.regular, size: 13))
                        .foregroundColor(Color(hex: "C66F8C"))
                }
                if let notes = routine.notes, !notes.isEmpty {
                    Text(notes)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.black.opacity(0.65))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private func loadRoutines() async {
        isLoading = true
        do {
            routines = try await ChatService.shared.fetchPatientRoutines(conversationId: conversationId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
