//
//  ReplyBar.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 15/02/2026.
//

import SwiftUI

struct ReplyBar: View {
    let canInteract: () -> Bool
    var body: some View {
        Button {
            if canInteract() {
                print("Reply tapped")
            }
        } label: {
            Text("Write a reply...")
        }
    }
}
