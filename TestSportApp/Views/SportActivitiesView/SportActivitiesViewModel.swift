//
//  SportActivitiesViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftUI

@MainActor final class SportActivitiesViewModel: ObservableObject {
    @Published var searchedText = ""
    @Published var selectedFilterType: SportActivityFilterType = .all
    @Published private var allSportActivities = [SportActivity]()
    
    private let dataStorageManager: DataStorageManager
    
    init(dataStorageManager: DataStorageManager) {
        self.dataStorageManager = dataStorageManager
    }
    
    var listSportActivities: [SportActivity] {
        searchedText.isEmpty ? filteredSportActivities : filteredSportActivities.filter { $0.activity.localizedStandardContains(searchedText) }
    }
    
    private var filteredSportActivities: [SportActivity] {
        allSportActivities.filter { activity in
            switch selectedFilterType {
            case .all:
                return true
            case .local:
                return activity.dataStorageType == DataStorageType.local.rawValue
            case .remote:
                return activity.dataStorageType == DataStorageType.remote.rawValue
            }
        }
    }
    
    func fetchAllSportActivities() async throws {
        allSportActivities = try await dataStorageManager.fetchAllSportActivities()
    }
    
    func deleteSportActivities(offsets: IndexSet) async throws {
        for index in offsets {
            try await dataStorageManager.deleteSportActivity(sportActivity: allSportActivities[index])
            allSportActivities.remove(at: index)
        }
    }
}
