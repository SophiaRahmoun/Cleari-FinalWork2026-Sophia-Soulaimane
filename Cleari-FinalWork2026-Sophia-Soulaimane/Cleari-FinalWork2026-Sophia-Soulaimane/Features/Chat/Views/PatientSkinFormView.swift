//
//  PatientSkinFormView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

struct PatientSkinFormView: View {
    let conversationId: Int
    @Environment(\.dismiss) private var dismiss
    @State private var form: PatientFormRecord?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                BeigeBackground()

                Group {
                    if isLoading {
                        ProgressView().tint(Color(hex: "C66F8C"))
                    } else if let form {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 14) {
                                formRow("How does your skin feel?", form.skinFeeling)
                                formRow("Reaction to products?", form.productReaction)
                                formRow("Flakiness?", form.flakiness)
                                formRow("Diagnosed condition?", form.diagnosedCondition)
                                formRow("Has allergies?", form.hasAllergies)
                                formRow("Allergy details", form.allergiesDetails)
                                formRow("Has skin issues?", form.hasSkinIssues)
                                formRow("Main concern", form.mainConcern)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 40)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 44))
                                .foregroundColor(Color(hex: "C66F8C").opacity(0.4))
                            Text("No skin form found for this patient.")
                                .font(AppFont.gillSwiftUI(.regular, size: 16))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Patient Skin Form")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(hex: "1A1018"))
                    }
                }
            }
            .task { await loadForm() }
        }
    }

    @ViewBuilder
    private func formRow(_ label: String, _ value: String?) -> some View {
        if let value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(AppFont.gillSwiftUI(.regular, size: 12))
                    .foregroundColor(.black.opacity(0.5))
                    .textCase(.uppercase)
                Text(value)
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
    }

    private func loadForm() async {
        isLoading = true
        do {
            form = try await ChatService.shared.fetchPatientForm(conversationId: conversationId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
