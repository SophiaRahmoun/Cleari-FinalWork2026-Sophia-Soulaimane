//
//  DermatologistConversationsView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//

import SwiftUI

@MainActor
final class DermatologistConversationsViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            conversations = try await ChatService.shared.fetchConversations()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct DermatologistConversationsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DermatologistConversationsViewModel()

    private let dark  = Color(hex: "1A1018")
    private let pink  = Color(hex: "C66F8C")
    private let beige = Color(hex: "F9BDB9")

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(dark)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 34)
                    .padding(.top, 60)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Messages")
                                .font(AppFont.gillSwiftUI(.regular, size: 42))
                                .foregroundColor(dark)

                            if viewModel.isLoading {
                                ProgressView().tint(dark)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 40)
                            } else if viewModel.conversations.isEmpty {
                                Text("No conversations yet.")
                                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                                    .foregroundColor(dark.opacity(0.6))
                                    .padding(.top, 20)
                            } else {
                                VStack(spacing: 14) {
                                    ForEach(viewModel.conversations) { conv in
                                        NavigationLink(
                                            destination: ChatDetailView(
                                                conversationId: conv.id,
                                                currentUserId: TokenStorage.shared.userId ?? 0,
                                                currentUserRole: "dermatologist",
                                                dermatologistName: conv.resolvedPatientName,
                                                currentUserProfileImageUrl: TokenStorage.shared.profilePictureUrl,
                                                dermatologistProfileImageUrl: nil
                                            )
                                        ) {
                                            conversationRow(conv)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }

                            if let err = viewModel.errorMessage {
                                Text(err)
                                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                                    .foregroundColor(dark)
                            }
                        }
                        .padding(.horizontal, 34)
                        .padding(.top, 26)
                        .padding(.bottom, 40)
                    }
                }
            }
            .task { await viewModel.load() }
        }
    }

    private func initials(for conv: Conversation) -> String {
        let name = conv.resolvedPatientName
        let letters = name.split(separator: " ").compactMap { $0.first }
        return String(letters.prefix(2)).uppercased()
    }

    private func conversationRow(_ conv: Conversation) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(LinearGradient(colors: [pink, beige], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 52, height: 52)
                .overlay(
                    Text(initials(for: conv))
                        .font(AppFont.gillSwiftUI(.bold, size: 20))
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(conv.resolvedPatientName)
                    .font(AppFont.gillSwiftUI(.bold, size: 16))
                    .foregroundColor(.white)
                Text(conv.status == "open" ? "Active" : "Closed")
                    .font(AppFont.gillSwiftUI(.regular, size: 13))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 14))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(dark)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
