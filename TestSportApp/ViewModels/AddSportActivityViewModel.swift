//
//  AddSportActivityViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftData
import SwiftUI

final class AddSportActivityViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @Published var activity: String = ""
    @Published var location: String = ""
    @Published var duration: Double = 0
    @Published var dataStorageType: DataStorageType = .all
    
    var isSaveDisabled: Bool {
        activity.isEmpty || location.isEmpty || duration == 0
    }
    
    func saveActivity() {
        let newActivity = SportActivity(
            activity: activity,
            location: location,
            duration: duration,
            dataStorageType: dataStorageType.rawValue
        )
        modelContext.insert(newActivity)
        
        if modelContext.hasChanges {
            try? modelContext.save()
        }
    }
}
