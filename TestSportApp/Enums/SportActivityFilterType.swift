//
//  SportActivityFilterType.swift
//  TestSportApp
//
//  Created by Martin Mikula on 01/08/2025.
//

import Foundation

enum SportActivityFilterType: Int, CaseIterable {
    case all
    case local
    case remote
    
    var title: String {
        switch self {
        case .all: return "All"
        case .local: return "Local"
        case .remote: return "Remote"
        }
    }
}
