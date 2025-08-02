//
//  DataStorageManager.swift
//  TestSportApp
//
//  Created by Martin Mikula on 02/08/2025.
//

import SwiftData
import SwiftUI

@MainActor final class DataStorageManager: ObservableObject {
    private let localDataManager = LocalDataManager()
    private let remoteDataManager = RemoteDataManager()
    
    func fetchAllSportActivities() async throws -> [SportActivity] {
        var allSportActivities = [SportActivity]()
        
        let localSportActivities: [SportActivity] = try localDataManager.fetchAllSportActivities()
        allSportActivities.append(contentsOf: localSportActivities)
        
        let remoteSportActivities: [SportActivity] = try await remoteDataManager.fetchAllSportActivities()
        allSportActivities.append(contentsOf: remoteSportActivities)
        
        return allSportActivities.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    func saveSportActivity(sportActivity: SportActivity, isNewSportActivity: Bool = false) async throws {
        guard let storageType = DataStorageType(rawValue: sportActivity.dataStorageType) else { return }
        
        switch storageType {
        case .local:
            try localDataManager.saveSportActivity(sportActivity: sportActivity, isNewSportActivity: isNewSportActivity)
        case .remote:
            try await remoteDataManager.saveSportActivity(sportActivity: sportActivity, isNewSportActivity: isNewSportActivity)
        }
    }
    
    func deleteSportActivity(sportActivity: SportActivity) async throws {
        guard let storageType = DataStorageType(rawValue: sportActivity.dataStorageType) else { return }
        
        switch storageType {
        case .local:
            try localDataManager.deleteSportActivity(sportActivity: sportActivity)
        case .remote:
            try await remoteDataManager.deleteSportActivity(sportActivity: sportActivity)
        }
    }
}
