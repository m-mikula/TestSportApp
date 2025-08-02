//
//  LocalDataManager.swift
//  TestSportApp
//
//  Created by Martin Mikula on 02/08/2025.
//

import SwiftData

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
