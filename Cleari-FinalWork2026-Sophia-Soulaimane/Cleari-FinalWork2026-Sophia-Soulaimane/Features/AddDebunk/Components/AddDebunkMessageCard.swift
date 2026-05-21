//
//  AddDebunkMessageCard.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 01/05/2026.
//

import SwiftUI

struct AddDebunkMessageCard: View {
    @Binding var message: String

    let imageName: String
    let name: String
    let role: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("AccentColor"))
                .shadow(color: .black.opacity(0.14), radius: 9, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    AvatarView(imageName: imageName, size: 40)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(AppFont.gillSwiftUI(.bold, size: 16))
                            .foregroundColor(Color(hex: "1A1018"))

                        Text(role)
                            .font(AppFont.gillSwiftUI(.regular, size: 13))
                            .foregroundColor(Color(hex: "1A1018"))
                    }
                }

                Divider()
                    .background(Color(hex: "1A1018").opacity(0.25))

                TextEditor(text: $message)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .font(AppFont.gillSwiftUI(.regular, size: 14))
                    .foregroundColor(Color(hex: "1A1018"))
                    .frame(height: 78)
                    .overlay(alignment: .topLeading) {
                        if message.isEmpty {
                            Text("Write your debunk message...")
                                .font(AppFont.gillSwiftUI(.regular, size: 14))
                                .foregroundColor(Color(hex: "1A1018").opacity(0.45))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                    }
            }
            .padding(18)
        }
        .frame(height: 170)
    }
}
