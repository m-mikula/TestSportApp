//
//  DataStorageManager.swift
//  TestSportApp
//
//  Created by Martin Mikula on 02/08/2025.
//

import SwiftData
import SwiftUI

@MainActor final class DataStorageManager: ObservableObject {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchAllSportActivities() async throws -> [SportActivity] {
        var allSportActivities = [SportActivity]()
        
        let localSportActivities: [SportActivity] = try modelContext.fetch(FetchDescriptor<SportActivity>())
        allSportActivities.append(contentsOf: localSportActivities)
        
        let remoteSportActivities: [SportActivity] = []
        allSportActivities.append(contentsOf: remoteSportActivities)
        
        return allSportActivities.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func saveSportActivity(sportActivity: SportActivity, isNewSportActivity: Bool = false) async throws {
        guard let storageType = DataStorageType(rawValue: sportActivity.dataStorageType) else { return }
        
        switch storageType {
        case .local:
            if isNewSportActivity {
                modelContext.insert(sportActivity)
            }
            
            if modelContext.hasChanges {
                try modelContext.save()
            }
        case .remote:
            
            throw DataStorageManagerError.remoteItemCouldNotBeSaved
        }
    }
    
    func deleteSportActivity(sportActivity: SportActivity) async throws {
        guard let storageType = DataStorageType(rawValue: sportActivity.dataStorageType) else { return }
        
        switch storageType {
        case .local:
            modelContext.delete(sportActivity)
            
            if modelContext.hasChanges {
                try modelContext.save()
            }
        case .remote:
            
            throw DataStorageManagerError.remoteItemCouldNotBeDeleted
        }
    }
}
