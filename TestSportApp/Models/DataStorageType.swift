//
//  DataStorageType.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftUI

enum DataStorageType: Int, CaseIterable {
    case local
    case remote
    
    var title: String {
        switch self {
        case .local: return "Local"
        case .remote: return "Remote"
        }
    }
    
    var color: Color {
        switch self {
        case .local: return .green.opacity(0.3)
        case .remote: return .red.opacity(0.3)
        }
    }
}
