//
//  Cleari_FinalWork2026_Sophia_SoulaimaneApp.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by admin on 14/02/2026.
//

import SwiftUI

@main
struct Cleari_FinalWork2026_Sophia_SoulaimaneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
