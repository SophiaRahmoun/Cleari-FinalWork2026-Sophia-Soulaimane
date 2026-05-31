//
//  FindDermatologistView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 29/04/2026.
//
import SwiftUI

struct FindDermatologistView: View {
    @StateObject private var viewModel = FindDermatologistViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradientBackground(
                    startHex: "C66F8C",
                    endHex: "F9BDB9"
                )
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 26) {
                        Text("Recommended\ndermatologist")
                            .font(AppFont.gillSwiftUI(.regular, size: 42))
                            .foregroundColor(Color(hex: "1A1018"))
                            .lineSpacing(4)
                        
                        HStack(spacing: 8) {
                            DermatologistFilterLabel(title: "Any", isSelected: true)
                            DermatologistFilterLabel(title: "Male")
                            DermatologistFilterLabel(title: "Female")
                            DermatologistFilterLabel(title: "On my location")
                        }
                        
                        Text("Top matches for you")
                            .font(AppFont.gillSwiftUI(.regular, size: 18))
                            .foregroundColor(Color(hex: "1A1018"))
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(Color(hex: "1A1018"))
                        } else {
                            VStack(spacing: 20) {
                                ForEach(viewModel.dermatologists) { dermatologist in
                                    DermatologistCard(dermatologist: dermatologist)
                                        .onTapGesture {
                                            Task {
                                                await viewModel.startChat(with: dermatologist)
                                            }
                                        }
                                }
                            }
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(AppFont.gillSwiftUI(.regular, size: 14))
                                .foregroundColor(Color(hex: "1A1018"))
                        }
                    }
                    .padding(.horizontal, 34)
                    
                    Spacer()
                    
                    ScanBottomBar()
                }
            }
            .task {
                await viewModel.loadDermatologists()
            }
            .navigationDestination(item: $viewModel.selectedConversation) { conversation in
                if let currentUser = authViewModel.currentUser {
                    ChatDetailView(
                        conversationId: conversation.id,
                        currentUserId: currentUser.id,
                        dermatologistName: viewModel.selectedDermatologist?.name ?? "Dermatologist",
                        currentUserProfileImage: "ProfileSample",
                        dermatologistProfileImage: viewModel.selectedDermatologist?.profileImage ?? "ProfileSample"
                    )
                }
            }
        }
    }
}
