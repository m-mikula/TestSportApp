//
//  AddSportActivityView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftData
import SwiftUI

struct AddSportActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddSportActivityViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddSportActivityViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SportTextFieldView(
                        text: $viewModel.activity,
                        placeholder: "Running, cycling, swimming...",
                        maxCount: 20,
                        labelTitle: "Activity",
                        labelSystemImage: "figure.run"
                    )
                    SportTextFieldView(
                        text: $viewModel.location,
                        placeholder: "Where did you sport?",
                        maxCount: 20,
                        labelTitle: "Location",
                        labelSystemImage: "map"
                    )
                    ActivityDurationPickerView(duration: $viewModel.duration)
                    DataStoragePickerView(selectedDataStorageType: $viewModel.dataStorageType)
                }
                .padding()
            }
            .toolbar {
                Button("Save") {
                    viewModel.saveActivity()
                    dismiss()
                }
                .disabled(viewModel.isSaveDisabled)
            }
            .navigationTitle("Add new activity")
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    let modelContainer = LocalDataManager.getModelContainer()
    
    AddSportActivityView(modelContext: modelContainer.mainContext)
}
