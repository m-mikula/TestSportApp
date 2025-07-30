//
//  TestSportAppApp.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftData
import SwiftUI

@main
struct TestSportAppApp: App {    
    let modelContainer: ModelContainer

    var body: some Scene {
        WindowGroup {
            SportActivitiesView(modelContext: modelContainer.mainContext)
        }
        .modelContainer(modelContainer)
    }
    
    init() {
        modelContainer = LocalDataManager.getModelContainer()
    }
}

struct LocalDataManager {
    static func getModelContainer() -> ModelContainer {
        let schema = Schema([
            SportActivity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
