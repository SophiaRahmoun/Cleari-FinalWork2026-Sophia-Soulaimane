//
//  UserHomeShellView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 15/02/2026.
//

import SwiftUI

private enum ShellDestination: Identifiable {
    case debunkFeed, profile, findDermatologist, scan, calendar
    case dermChat, dermRequests
    case postDetail(CommunityPost)

    var id: String {
        switch self {
        case .debunkFeed: return "debunkFeed"
        case .profile: return "profile"
        case .findDermatologist: return "findDermatologist"
        case .scan: return "scan"
        case .calendar: return "calendar"
        case .dermChat: return "dermChat"
        case .dermRequests: return "dermRequests"
        case .postDetail(let p): return "post-\(p.id)"
        }
    }
}

struct UserHomeShellView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var destination: ShellDestination? = nil

    private var isDermatologist: Bool {
        TokenStorage.shared.userRole == "dermatologist"
    }

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(item: $destination) { dest in
                switch dest {
                case .debunkFeed:
                    DebunkFeedView(isDermatologist: false)
                case .profile:
                    UserProfileView()
                case .findDermatologist:
                    FindDermatologistView()
                        .environmentObject(authViewModel)
                case .scan:
                    CameraCaptureView()
                case .calendar:
                    MyAppointmentsView()
                case .dermChat:
                    DermatologistConversationsView()
                case .dermRequests:
                    DermatologistAppointmentRequestsView()
                case .postDetail(let post):
                    PostDetailView(post: post)
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if isDermatologist {
            dermatologistShell
        } else {
            userShell
        }
    }

    private var userShell: some View {
        FeedView(
            onFakeTrendsTapped: { destination = .debunkFeed },
            onProfileTapped: { destination = .profile },
            onPostSelected: { post in destination = .postDetail(post) }
        )
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ScanBottomBar(
                onHomeTapped: nil,
                onFindDermatologistTapped: { destination = .findDermatologist },
                onScanTapped: { destination = .scan },
                onCalendarTapped: { destination = .calendar }
            )
            .padding(.bottom, 8)
        }
    }

    private var dermatologistShell: some View {
        FeedView()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                dermBottomBar
                    .padding(.bottom, 8)
            }
    }

    private var dermBottomBar: some View {
        HStack(spacing: 0) {
            dermTab(icon: "bubble.left.and.bubble.right", isActive: { if case .dermChat = destination { return true }; return false }()) { destination = .dermChat }
            Spacer()
            dermTab(icon: "calendar", isActive: { if case .dermRequests = destination { return true }; return false }()) { destination = .dermRequests }
        }
        .padding(.horizontal, 52)
        .padding(.vertical, 12)
        .background(Color(hex: "C97A94"))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 24)
    }

    private func dermTab(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(isActive ? .white : Color(hex: "1A1018"))
        }
        .buttonStyle(.plain)
    }
}
