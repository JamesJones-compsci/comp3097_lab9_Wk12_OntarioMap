//
//  Lab9_OntarioMapApp.swift
//  Lab9_OntarioMap
//
//  Created by Tech on 2026-04-09.
//

import SwiftUI
import CoreData

@main
struct Lab9_OntarioMapApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
