//
//  TestSportAppApp.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftData
import SwiftUI

@main
struct TestSportAppApp: App {
    @StateObject private var dataStorageManager: DataStorageManager
    
    var body: some Scene {
        WindowGroup {
            SportActivitiesView(dataStorageManager: dataStorageManager)
        }
    }
    
    init() {
        let modelContainer = LocalDataManager.getModelContainer()
        _dataStorageManager = StateObject(wrappedValue: DataStorageManager(modelContext: modelContainer.mainContext))
    }
}
