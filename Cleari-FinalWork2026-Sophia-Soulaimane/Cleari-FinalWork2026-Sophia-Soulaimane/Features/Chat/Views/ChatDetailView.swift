//
//  ChatDetailView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 30/05/2026.
//


import SwiftUI

struct ChatDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ChatViewModel

    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    
    let currentUserRole: String
    let dermatologistName: String
    let currentUserProfileImageUrl: String?
    let dermatologistProfileImageUrl: String?

    private let beige = Color(hex: "FDF3EB")
    private let pink = Color(hex: "C66F8C")
    private let darkBrown = Color(hex: "1E141D")

    init(
        conversationId: Int,
        currentUserId: Int,
        currentUserRole: String = "user",
        dermatologistName: String = "Dermatologist",
        currentUserProfileImageUrl: String? = nil,
        dermatologistProfileImageUrl: String? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: ChatViewModel(
                conversationId: conversationId,
                currentUserId: currentUserId
            )
        )

        self.currentUserRole = currentUserRole
        self.dermatologistName = dermatologistName
        self.currentUserProfileImageUrl = currentUserProfileImageUrl
        self.dermatologistProfileImageUrl = dermatologistProfileImageUrl
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(darkBrown)
                    Spacer()
                } else {
                    messagesList
                }

                messageInput
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadMessages()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                Task {
                    await viewModel.sendImageMessage(image: image)
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                Task {
                    await viewModel.sendMessage(overrideContent: url.lastPathComponent)
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(darkBrown)
            }

            ProfileAvatarView(
                imageUrl: dermatologistProfileImageUrl,
                size: 46,
                action: {
                    openProfile(for: "dermatologist")
                }
            )

            TypographyLabel(
                text: dermatologistName,
                style: .h2,
                color: darkBrown
            )

            Spacer()

            if currentUserRole == "dermatologist" {
                Menu {
                    Button {
                        openSkinScan()
                    } label: {
                        Label("View skin scan", systemImage: "camera.viewfinder")
                    }

                    Button {
                        openSkinForm()
                    } label: {
                        Label("View skin form", systemImage: "doc.text")
                    }

                    Button {
                        requestAppointment()
                    } label: {
                        Label("Suggest appointment", systemImage: "calendar.badge.plus")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(darkBrown)
                        .padding(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 16) {
                    if let conversation = viewModel.conversation {
                        consultationContext(conversation)
                    }

                    ForEach(viewModel.messages) { message in
                        MessageBubble(
                            message: message,
                            isCurrentUser: message.senderId == viewModel.currentUserId,
                            currentUserProfileImageUrl: currentUserProfileImageUrl,
                            otherUserProfileImageUrl: dermatologistProfileImageUrl,
                            onProfileTap: {
                                openProfile(for: message.senderRole)
                            }
                        )
                        .id(message.id)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            .onChange(of: viewModel.messages.count) {
                if let lastId = viewModel.messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
        }
    }

    private func consultationContext(_ conversation: Conversation) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            TypographyLabel(
                text: "Consultation context",
                style: .button,
                color: beige
            )

            if let scanId = conversation.scanId {
                TypographyLabel(
                    text: "Skin scan linked • ID \(scanId)",
                    style: .caption,
                    color: beige.opacity(0.85)
                )
            }

            if let formId = conversation.formId {
                TypographyLabel(
                    text: "Skin form linked • ID \(formId)",
                    style: .caption,
                    color: beige.opacity(0.85)
                )
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(darkBrown)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 28)
    }

    private var messageInput: some View {
        HStack(spacing: 12) {
            Button {
                showImagePicker = true
            } label: {
                Image(systemName: "camera")
                    .font(.system(size: 22))
                    .foregroundColor(darkBrown)
            }

            Button {
                showDocumentPicker = true
            } label: {
                Image(systemName: "link")
                    .font(.system(size: 22))
                    .foregroundColor(darkBrown)
            }

            TextField("", text: $viewModel.newMessage, prompt: Text("Write message...")
                .foregroundColor(beige.opacity(0.7))
            )
            .font(AppFont.gillSwiftUI(.regular, size: 16))
            .foregroundColor(beige)
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(darkBrown)
            .clipShape(Capsule())

            Button {
                Task {
                    await viewModel.sendMessage()
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(beige)
                    .padding(11)
                    .background(pink)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(beige)
    }

    private func openProfile(for role: String) {
        print("Navigate to profile page for: \(role)")
    }

    private func openSkinScan() {
        guard let scanId = viewModel.conversation?.scanId else {
            print("No skin scan linked to this conversation")
            return
        }

        print("Navigate to skin scan detail: \(scanId)")
    }

    private func openSkinForm() {
        guard let formId = viewModel.conversation?.formId else {
            print("No skin form linked to this conversation")
            return
        }

        print("Navigate to skin form detail: \(formId)")
    }

    private func requestAppointment() {
        Task {
            await viewModel.requestAppointment()
        }
    }
    
}

#Preview("Chat Detail - User") {
    ChatDetailPreviewView(currentUserRole: "user")
}


#Preview("Chat Detail - Dermatologist") {
    ChatDetailPreviewView(currentUserRole: "dermatologist")
}

private struct ChatDetailPreviewView: View {
    let currentUserRole: String

    private let beige = Color(hex: "FDF3EB")
    private let pink = Color(hex: "C66F8C")
    private let darkBrown = Color(hex: "1E141D")

    private let messages: [ChatMessage] = [
        ChatMessage(
            id: 1,
            conversationId: 1,
            senderId: 1,
            senderRole: "user",
            content: "Hi Doctor, I uploaded my skin scan. I have redness around my cheeks and I’m not sure if it’s irritation or acne.",
            messageType: "text",
            isRead: true,
            createdAt: nil
        ),
        ChatMessage(
            id: 2,
            conversationId: 1,
            senderId: 2,
            senderRole: "dermatologist",
            content: "Hi Sophia, I checked your scan and your form. The redness looks more like irritation than active acne.",
            messageType: "text",
            isRead: true,
            createdAt: nil
        ),
        ChatMessage(
            id: 3,
            conversationId: 1,
            senderId: 1,
            senderRole: "user",
            content: "https://res.cloudinary.com/demo/image/upload/sample.jpg",
            messageType: "image",
            isRead: true,
            createdAt: nil
        ),
        ChatMessage(
            id: 4,
            conversationId: 1,
            senderId: 2,
            senderRole: "dermatologist",
            content: "I suggest booking an appointment so we can review this properly.",
            messageType: "appointment_request",
            isRead: false,
            createdAt: nil
        )
    ]

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(spacing: 16) {
                        consultationContext

                        ForEach(messages) { message in
                            MessageBubble(
                                message: message,
                                isCurrentUser: message.senderId == 1,
                                currentUserProfileImageUrl: nil,
                                otherUserProfileImageUrl: nil,
                                onProfileTap: {}
                            )
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }

                messageInput
            }
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: "chevron.left")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(darkBrown)

            ProfileAvatarView(
                imageName: "dermato-profile",
                size: 46,
                action: {}
            )

            TypographyLabel(
                text: "Dr. Sarah Ben Ali",
                style: .h2,
                color: darkBrown
            )

            Spacer()

            if currentUserRole == "dermatologist" {
                Image(systemName: "ellipsis")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(darkBrown)
                    .padding(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private var consultationContext: some View {
        VStack(alignment: .leading, spacing: 6) {
            TypographyLabel(
                text: "Consultation context",
                style: .button,
                color: beige
            )

            TypographyLabel(
                text: "Skin scan linked • ID 1",
                style: .caption,
                color: beige.opacity(0.85)
            )

            TypographyLabel(
                text: "Skin form linked • ID 1",
                style: .caption,
                color: beige.opacity(0.85)
            )
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(darkBrown)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 28)
    }

    private var messageInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "camera")
                .font(.system(size: 22))
                .foregroundColor(darkBrown)

            Image(systemName: "link")
                .font(.system(size: 22))
                .foregroundColor(darkBrown)

            TypographyLabel(
                text: "Write message...",
                style: .body,
                color: beige.opacity(0.7)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(darkBrown)
            .clipShape(Capsule())

            Image(systemName: "paperplane.fill")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(beige)
                .padding(11)
                .background(pink)
                .clipShape(Circle())
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(beige)
    }
}
