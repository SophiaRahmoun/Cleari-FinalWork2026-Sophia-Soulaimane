//
//  PostActionsRow.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 21/05/2026.
//

import SwiftUI

struct PostActionsRow: View {
    let canInteract: () -> Bool
    var body: some View {
        HStack {
            Button {
                if canInteract() {
                    print("Like post")
                }
            } label: {
                Image(systemName: "heart")
            }
            Button {
                if canInteract() {
                    print("Comment post")
                }
            } label: {
                Image(systemName: "message")
            }
        }

    }

}
