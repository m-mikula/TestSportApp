//
//  DataStorageManagerError.swift
//  TestSportApp
//
//  Created by Martin Mikula on 02/08/2025.
//

import Foundation

enum DataStorageManagerError: Error {
    case remoteItemCouldNotBeSaved
    case remoteItemCouldNotBeDeleted
    
    var customErrorMessage: String {
        switch self {
        case .remoteItemCouldNotBeSaved: return "Remote sport activity could not be saved."
        case .remoteItemCouldNotBeDeleted: return "Remote sport activity could not be deleted."
        }
    }
}
