//
//  AddSportActivityViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftData
import SwiftUI

enum SportActivityDetailViewType {
    case new, edit
    
    var navigationTitle: String {
        switch self {
        case .new: return "New activity"
        case .edit: return "Edit activity"
        }
    }
    
    var saveButtonTitle: String {
        switch self {
        case .new, .edit: return "Save"
        }
    }
}

final class SportActivityDetailViewModel: ObservableObject {
    private var modelContext: ModelContext
    private var sportActivity: SportActivity
    
    private(set) var type: SportActivityDetailViewType = .new
    
    init(
        modelContext: ModelContext,
        sportActivity: SportActivity? = nil
    ) {
        self.modelContext = modelContext
        
        if let sportActivity = sportActivity {
            self.sportActivity = sportActivity
            
            self.activity = sportActivity.activity
            self.location = sportActivity.location
            self.duration = sportActivity.duration
            
            self.dataStorageType = DataStorageType(rawValue: sportActivity.dataStorageType) ?? .local
            
            self.type = .edit
        } else {
            self.sportActivity = SportActivity(
                activity: "",
                location: "",
                duration: 0,
                dataStorageType: DataStorageType.local.rawValue
            )
            
            self.type = .new
        }
    }
    
    @Published var activity: String = ""
    @Published var location: String = ""
    @Published var duration: Double = 0
    @Published var dataStorageType: DataStorageType = .local
    
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
        
        modelContext.insert(sportActivity)
        
        if modelContext.hasChanges {
            try? modelContext.save()
        }
    }
}
