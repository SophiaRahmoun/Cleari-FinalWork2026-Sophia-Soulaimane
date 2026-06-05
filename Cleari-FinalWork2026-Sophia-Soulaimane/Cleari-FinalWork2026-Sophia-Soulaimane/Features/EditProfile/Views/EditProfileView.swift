//
//  EditProfileView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 13/05/2026.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var pronouns = "she/her"
    @State private var skinType = ""
    @State private var isLoading = false
    @State private var successMessage: String?
    @State private var errorMessage: String?
    @State private var showChangePasswordView = false
    @State private var showImagePicker = false
    @State private var profileImageUrl: String?
    @State private var selectedImage: UIImage?


    var body: some View {
        ZStack {
            LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header

                profilePictureSection
                    .padding(.top, 55)

                profileInfoSection
                    .padding(.top, 70)

                Spacer()
                    .frame(height: 30)
                
                if let successMessage {
                    Text(successMessage)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                PrimaryButton(title: "Done") {
                    Task {
                        do {

                            try await UserProfileService.shared.updateUsername(
                                username: username
                            )

                            let message = try await UserProfileService.shared.updatePronouns(
                                pronouns: pronouns
                            )

                            successMessage = message
                            errorMessage = nil

                            try await Task.sleep(nanoseconds: 800_000_000)
                            dismiss()

                        } catch {

                            successMessage = nil

                            if error.localizedDescription.contains("Username already exists") {
                                errorMessage = "Username already taken"
                            } else {
                                errorMessage = "Could not update profile"
                            }
                        }
                    }
                }
                .padding(.horizontal, 34)
                /*PrimaryButton(title: "Done") {
                    print("Profile saved")
                    print("Name:", fullName)
                    print("Username:", username)
                    print("Pronouns:", pronouns)
                    print("Skin type:", skinType)
                }
                 */
                .padding(.horizontal, 34)

                Button {
                    print("Switch to dermatologist account tapped")
                } label: {
                    Text("Switch to dermatologist account")
                        .font(AppFont.gillSwiftUI(.regular, size: 24))
                        .foregroundColor(Color(hex: "1A1018"))
                }
                .buttonStyle(.plain)
                .padding(.top, 85)
                .padding(.bottom, 45)
            }
            .padding(.horizontal, 34)
            .padding(.top, 40)
        }
        .task {
            await loadProfile()
        }
        .fullScreenCover(isPresented: $showChangePasswordView) {
            ChangePasswordView()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                selectedImage = image
                Task {
                    guard let data = image.jpegData(compressionQuality: 0.8) else { return }
                    do {
                        let newUrl = try await UserProfileService.shared.updateProfilePicture(imageData: data)
                        profileImageUrl = newUrl
                    } catch {
                        errorMessage = "Could not upload profile picture"
                    }
                }
            }
        }
    }

    private func loadProfile() async {
        isLoading = true

        do {
            let user = try await UserProfileService.shared.fetchCurrentUser()

            let firstName = user.firstName ?? ""
            let lastName = user.lastName ?? ""

            skinType = user.skinType ?? ""
            pronouns = user.pronouns ?? ""
            profileImageUrl = user.profilePictureUrl

            fullName = "\(firstName) \(lastName)"
                .trimmingCharacters(in: .whitespaces)

            username = user.username
            email = user.email

        } catch {
            print("EDIT PROFILE LOAD ERROR:", error.localizedDescription)
        }

        isLoading = false
    }
}

extension EditProfileView {
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(.top, 20)
    }

    private var profilePictureSection: some View {
        VStack(spacing: 22) {
            if let selected = selectedImage {
                Image(uiImage: selected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .clipShape(Circle())
            } else {
                AvatarView(imageUrl: profileImageUrl, size: 155)
            }

            Button {
                showImagePicker = true
            } label: {
                Text("Edit picture")
                    .font(AppFont.gillSwiftUI(.bold, size: 24))
                    .foregroundColor(Color(hex: "1A1018"))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }

    private var profileInfoSection: some View {
        VStack(spacing: 30) {
            EditProfileRow(title: "Name", value: fullName)

            HStack {
                Text("Username")
                    .font(AppFont.gillSwiftUI(.regular, size: 18))
                    .foregroundColor(Color(hex: "1A1018"))

                Spacer()

                TextField("Username", text: $username)
                    .multilineTextAlignment(.trailing)
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(Color(hex: "1A1018").opacity(0.45))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }

            pronounsRow

            EditProfileRow(
                title: "Skin Type",
                value: skinType.isEmpty ? "Not completed" : skinType
            )
            Spacer()
                .frame(height: 15)

            EditProfileRow(
                title: "E-mail",
                value: email,
                isDisabled: true
            )

            EditProfileRow(
                title: "Password",
                value: "",
                showChevron: true
            ) {
                showChangePasswordView = true
            }
        }
    }

    private var pronounsRow: some View {
        HStack {
            Text("Pronouns")
                .font(AppFont.gillSwiftUI(.regular, size: 18))
                .foregroundColor(Color(hex: "1A1018"))

            Spacer()

            HStack(spacing: 8) {
                pronounButton("she/her")
                pronounButton("he/him")
            }
        }
    }

    private func pronounButton(_ value: String) -> some View {
        Button {
            pronouns = value
        } label: {
            Text(value)
                .font(AppFont.gillSwiftUI(.regular, size: 13))
                .foregroundColor(pronouns == value ? .white : Color(hex: "1A1018"))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(pronouns == value ? Color(hex: "1A1018") : Color.white.opacity(0.55))
                )
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "1A1018"), lineWidth: 1.2)
                )
        }
        .buttonStyle(.plain)
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
