//
//  DataStoragePickerView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftUI

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
