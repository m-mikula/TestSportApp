//
//  SportActivitiesViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftData
import SwiftUI

final class SportActivitiesViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchAllSportActivities()
    }
    
    @Published private(set) var sportActivities = [SportActivity]()
    
    func fetchAllSportActivities() {
        do {
            sportActivities = try modelContext.fetch(FetchDescriptor<SportActivity>())
        } catch {
            sportActivities = []
        }
    }
    
    func filterSportActivities(by dataStorageType: DataStorageType = .all) {
        do {
            let dataStorageTypeRawValue = dataStorageType.rawValue // Workaround - cannot use another type/entity in predicate
            
            sportActivities = try modelContext.fetch(
                FetchDescriptor<SportActivity>(
                    predicate: #Predicate { activity in
                        activity.dataStorageType == dataStorageTypeRawValue
                    }
                )
            )
        } catch {
            sportActivities = []
        }
    }
    
    func deleteSportActivities(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sportActivities[index])
            
            if modelContext.hasChanges {
                try? modelContext.save()
            }
        }
        fetchAllSportActivities()
    }
}
