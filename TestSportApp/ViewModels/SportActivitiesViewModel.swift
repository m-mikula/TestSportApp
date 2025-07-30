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
