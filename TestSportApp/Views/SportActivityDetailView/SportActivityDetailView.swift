//
//  AddSportActivityView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

struct SportActivityDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: SportActivityDetailViewModel
    
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
                    ActivityDurationPickerView(viewModel: ActivityDurationPickerViewModel(duration: $viewModel.duration))
                    DataStoragePickerView(selectedDataStorageType: $viewModel.dataStorageType)
                }
                .padding()
            }
            .toolbar {
                if viewModel.type == .new {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.type.saveButtonTitle) {
                        viewModel.saveActivity()
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
            .navigationTitle(viewModel.type.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    let modelContainer = LocalDataManager.getModelContainer()
    
    SportActivityDetailView(viewModel: SportActivityDetailViewModel(modelContext: modelContainer.mainContext))
}
