//
//  EcoTrackApp.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import SwiftUI
import CoreData

@main
struct EcoTrackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
