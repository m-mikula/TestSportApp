//
//  Item.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import Foundation
import SwiftData

@Model
final class SportActivity: Identifiable {
    private(set) var id: String = UUID().uuidString
    
    var activity: String
    var location: String
    var duration: Double
    var dataStorageType: Int
    
    init(
        activity: String,
        location: String,
        duration: Double,
        dataStorageType: Int
    ) {
        self.activity = activity
        self.location = location
        self.duration = duration
        self.dataStorageType = dataStorageType
    }
}
