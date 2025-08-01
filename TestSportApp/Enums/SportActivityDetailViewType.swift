//
//  SportActivityDetailViewType.swift
//  TestSportApp
//
//  Created by Martin Mikula on 01/08/2025.
//

import Foundation

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
