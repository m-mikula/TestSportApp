//
//  AddSportActivityViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftUI

@MainActor final class SportActivityDetailViewModel: ObservableObject {
    @Published var activity: String = ""
    @Published var location: String = ""
    @Published var duration: Double = 0
    @Published var dataStorageType: DataStorageType = .local
    
    private var sportActivity: SportActivity
    private let dataStorageManager: DataStorageManager
    @Published private(set) var type: SportActivityDetailViewType = .new
    
    init(dataStorageManager: DataStorageManager, sportActivity: SportActivity? = nil) {
        self.dataStorageManager = dataStorageManager
        
        if let sportActivity = sportActivity {
            self.sportActivity = sportActivity
            
            activity = sportActivity.activity
            location = sportActivity.location
            duration = sportActivity.duration
            
            dataStorageType = DataStorageType(rawValue: sportActivity.dataStorageType) ?? .local
            
            type = .edit
        } else {
            self.sportActivity = SportActivity(
                activity: "",
                location: "",
                duration: 0,
                dataStorageType: DataStorageType.local.rawValue,
                timestamp: Date().timeIntervalSinceReferenceDate
            )
            
            type = .new
        }
    }
    
    var isSaveDisabled: Bool {
        switch type {
        case .new:
            return activity.isEmpty || location.isEmpty || duration == 0
        case .edit:
            return sportActivity.activity == activity &&
                    sportActivity.location == location &&
                    sportActivity.duration == duration &&
                    sportActivity.dataStorageType == dataStorageType.rawValue
        }
    }
    
    func saveActivity() async throws {
        sportActivity.activity = activity
        sportActivity.location = location
        sportActivity.duration = duration
        sportActivity.dataStorageType = dataStorageType.rawValue
        sportActivity.timestamp = Date().timeIntervalSinceReferenceDate
        
        try await dataStorageManager.saveSportActivity(sportActivity: sportActivity, isNewSportActivity: type == .new)
    }
}
