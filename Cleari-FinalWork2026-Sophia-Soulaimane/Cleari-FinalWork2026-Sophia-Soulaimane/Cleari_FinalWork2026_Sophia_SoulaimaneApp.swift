//
//  Cleari_FinalWork2026_Sophia_SoulaimaneApp.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 14/02/2026.
//

import SwiftUI
import UIKit

@main
struct Cleari_FinalWork2026_Sophia_SoulaimaneApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        printFonts()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    private func printFonts() {
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}
