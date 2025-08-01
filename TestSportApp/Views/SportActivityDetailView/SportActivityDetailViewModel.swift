//
//  AddSportActivityViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftData
import SwiftUI

final class SportActivityDetailViewModel: ObservableObject {
    @Published var activity: String = ""
    @Published var location: String = ""
    @Published var duration: Double = 0
    @Published var dataStorageType: DataStorageType = .local
    
    private var modelContext: ModelContext
    private var sportActivity: SportActivity
    
    private(set) var type: SportActivityDetailViewType
    
    init(
        modelContext: ModelContext,
        sportActivity: SportActivity? = nil
    ) {
        self.modelContext = modelContext
        
        if let sportActivity = sportActivity {
            self.sportActivity = sportActivity
            
            activity = sportActivity.activity
            location = sportActivity.location
            duration = sportActivity.duration
            
            dataStorageType = DataStorageType(rawValue: sportActivity.dataStorageType) ?? .local
            
            type = .edit
        } else {
            self.sportActivity = SportActivity(activity: "", location: "", duration: 0, dataStorageType: DataStorageType.local.rawValue)
            
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
    
    func saveActivity() {
        sportActivity.activity = activity
        sportActivity.location = location
        sportActivity.duration = duration
        sportActivity.dataStorageType = dataStorageType.rawValue
        
        if type == .new {
            modelContext.insert(sportActivity)
        }
        
        if modelContext.hasChanges {
            try? modelContext.save()
        }
    }
}
