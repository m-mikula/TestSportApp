//
//  DataStoragePickerView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftUI

enum DataStorageType: Int, CaseIterable {
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
    
    var color: Color {
        switch self {
        case .all: return .blue
        case .local: return .green
        case .remote: return .red
        }
    }
}

struct DataStoragePickerView: View {
    @Binding var selectedDataStorageType: DataStorageType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Data storage".uppercased(), systemImage: "internaldrive")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Picker("Data storage", selection: $selectedDataStorageType) {
                ForEach(DataStorageType.allCases, id: \.self) { dataStorageType in
                    Text(dataStorageType.title)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    DataStoragePickerView(selectedDataStorageType: .constant(.all))
}
