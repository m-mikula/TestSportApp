//
//  LocalDataManager.swift
//  TestSportApp
//
//  Created by Martin Mikula on 02/08/2025.
//

import SwiftData

@MainActor final class LocalDataManager {
    private var modelContainer: ModelContainer
    
    init() {
        let schema = Schema([
            SportActivity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func fetchAllSportActivities() throws -> [SportActivity] {
        try modelContainer.mainContext.fetch(FetchDescriptor<SportActivity>())
    }
    
    func saveSportActivity(sportActivity: SportActivity, isNewSportActivity: Bool = false) throws {
        if isNewSportActivity {
            modelContainer.mainContext.insert(sportActivity)
        }
        
        if modelContainer.mainContext.hasChanges {
            try modelContainer.mainContext.save()
        }
    }
    
    func deleteSportActivity(sportActivity: SportActivity) throws {
        modelContainer.mainContext.delete(sportActivity)
        
        if modelContainer.mainContext.hasChanges {
            try modelContainer.mainContext.save()
        }
    }
}
