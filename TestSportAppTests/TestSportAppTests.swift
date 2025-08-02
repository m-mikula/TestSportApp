//
//  TestSportAppTests.swift
//  TestSportAppTests
//
//  Created by Martin Mikula on 29/07/2025.
//

import Foundation
import Testing
@testable import TestSportApp

extension Tag {
    enum data_storage {}
}

extension Tag.data_storage {
    @Tag static var local: Tag
    @Tag static var remote: Tag
}

@Suite("Local data storage") struct LocalDataStorageTests {
    
    @Test("Save, edit, delete, fetch all", .tags(.data_storage.local)) func localDataFlow() async throws {
        let localDataManager = await LocalDataManager()
        
        let sportActivity = SportActivity(
            activity: "New activity (local)",
            location: "Vienna",
            duration: 8600,
            dataStorageType: DataStorageType.local.rawValue,
            timestamp: 8600
        )
        try await localDataManager.saveSportActivity(sportActivity: sportActivity, isNewSportActivity: true)
        
        let isNewItemSaved = try await localDataManager.fetchAllSportActivities().filter({ $0 == sportActivity }).count == 1
        
        try #require(isNewItemSaved, "Error: new activity not saved.")
        
        sportActivity.activity = "Edited activity (local)"
        
        try await localDataManager.saveSportActivity(sportActivity: sportActivity, isNewSportActivity: false)
        
        let isEditedItemSaved = try await localDataManager.fetchAllSportActivities().filter({ $0.activity == "Edited activity (local)" }).count == 1
        
        try #require(isEditedItemSaved, "Error: edited activity not saved.")
        
        try await localDataManager.deleteSportActivity(sportActivity: sportActivity)
        
        let isItemDeleted = try await localDataManager.fetchAllSportActivities().filter({ $0 == sportActivity }).isEmpty
        
        #expect(isItemDeleted, "Error: activity not deleted.")
    }
}

@Suite("Remote data storage") struct RemoteDataStorageTests {
    
    @Test("Save, edit, delete, fetch all", .tags(.data_storage.remote)) func remoteDataFlow() async throws {
        let remoteDataManager = await RemoteDataManager()
        
        let newSportActivity = SportActivity(
            activity: "New activity (remote)",
            location: "Vienna",
            duration: 8600,
            dataStorageType: DataStorageType.remote.rawValue,
            timestamp: 8600
        )
        try await remoteDataManager.saveSportActivity(sportActivity: newSportActivity, isNewSportActivity: true)
        
        let savedItems = try await remoteDataManager.fetchAllSportActivities()
            
        let isNewItemSaved = savedItems.filter({
            $0.activity == "New activity (remote)" &&
            $0.location == "Vienna" &&
            $0.duration == 8600 &&
            $0.dataStorageType == DataStorageType.remote.rawValue &&
            $0.timestamp == 8600
        }).count == 1
        
        try #require(isNewItemSaved, "Error: new activity not saved.")
        
        let editedItem = try #require(savedItems.first)
        editedItem.activity = "Edited activity (remote)"
        
        try await remoteDataManager.saveSportActivity(sportActivity: editedItem, isNewSportActivity: false)
        
        let isEditedItemSaved = try await remoteDataManager.fetchAllSportActivities().filter({ $0.activity == "Edited activity (remote)" }).count == 1
        
        try #require(isEditedItemSaved, "Error: edited activity not saved.")
        
        try await remoteDataManager.deleteSportActivity(sportActivity: editedItem)
        
        let isItemDeleted = try await remoteDataManager.fetchAllSportActivities().filter({ $0 == editedItem }).isEmpty
        
        #expect(isItemDeleted, "Error: activity not deleted.")
    }
}
