//
//  SportActivitiesViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftData
import SwiftUI

enum SportActivityFilterType: Int, CaseIterable {
    case all
    case local
    case remote
    
    var title: String {
        switch self {
        case .all: return "All"
        case .local: return "Local"
        case .remote: return "Remote"
        }
    }
}

final class SportActivitiesViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    private(set) var selectedFilterType: SportActivityFilterType = .all
    @Published private(set) var sportActivities = [SportActivity]()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchAllSportActivities()
    }
    
    func fetchAllSportActivities() {
        do {
            sportActivities = try modelContext.fetch(FetchDescriptor<SportActivity>())
        } catch {
            sportActivities = []
        }
    }
    
    func filterSportActivities(by filterType: SportActivityFilterType) {
        do {
            selectedFilterType = filterType
            let filterTypeRawValue = filterType.rawValue // Workaround - cannot use another type/entity in predicate
            
            switch filterType {
            case .all:
                sportActivities = try modelContext.fetch(FetchDescriptor<SportActivity>())
            case .local:
                let dataStorageTypeLocalRawValue: Int = DataStorageType.local.rawValue
                
                sportActivities = try modelContext.fetch(
                    FetchDescriptor<SportActivity>(predicate: #Predicate { $0.dataStorageType == dataStorageTypeLocalRawValue })
                )
            case .remote:
                let dataStorageTypeRemoteRawValue: Int = DataStorageType.remote.rawValue
                
                sportActivities = try modelContext.fetch(
                    FetchDescriptor<SportActivity>(predicate: #Predicate { $0.dataStorageType == dataStorageTypeRemoteRawValue })
                )
            }
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
