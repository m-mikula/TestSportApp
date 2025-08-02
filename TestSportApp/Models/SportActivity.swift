//
//  Item.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import FirebaseFirestore
import Foundation
import SwiftData

/// Model created because its was not possible to use property wrapper @DocumentID with @Model SwiftData property wrapper
struct FirebaseSportActivity: Codable {
    /// Manual setup of this property produces error (see logs and property wrapper implementation)
    @DocumentID var id: String?
    
    let activity: String
    let location: String
    let duration: Double
    let dataStorageType: Int
    let timestamp: Double
    
    init(id: String? = nil, activity: String, location: String, duration: Double, dataStorageType: Int, timestamp: Double) {
        self.id = id
        self.activity = activity
        self.location = location
        self.duration = duration
        self.dataStorageType = dataStorageType
        self.timestamp = timestamp
    }
}

@Model final class SportActivity: Identifiable, Sendable {
    private(set) var id: String = UUID().uuidString
    
    var firebaseDocumentID: String?
    
    var activity: String
    var location: String
    var duration: Double
    var dataStorageType: Int
    var timestamp: Double
    
    init(
        activity: String,
        location: String,
        duration: Double,
        dataStorageType: Int,
        timestamp: Double,
        firebaseDocumentID: String? = nil
    ) {
        self.activity = activity
        self.location = location
        self.duration = duration
        self.dataStorageType = dataStorageType
        self.timestamp = timestamp
        self.firebaseDocumentID = firebaseDocumentID
    }
}

extension SportActivity {
    var firebaseSportActivity: FirebaseSportActivity {
        FirebaseSportActivity(
            id: firebaseDocumentID,
            activity: activity,
            location: location,
            duration: duration,
            dataStorageType: dataStorageType,
            timestamp: timestamp
        )
    }
    
    convenience init(from firebaseSportActivity: FirebaseSportActivity) {
        self.init(
            activity: firebaseSportActivity.activity,
            location: firebaseSportActivity.location,
            duration: firebaseSportActivity.duration,
            dataStorageType: firebaseSportActivity.dataStorageType,
            timestamp: firebaseSportActivity.timestamp,
            firebaseDocumentID: firebaseSportActivity.id
        )
    }
}
