//
//  AddSportActivityView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

struct SportActivityDetailView: View {
    @State private var isShowingErrorAlert = false
    @State private var errorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SportActivityDetailViewModel
    
    init(dataStorageManager: DataStorageManager, sportActivity: SportActivity? = nil) {
        _viewModel = StateObject(wrappedValue: SportActivityDetailViewModel(dataStorageManager: dataStorageManager, sportActivity: sportActivity))
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
                        Task {
                            do {
                                try await viewModel.saveActivity()
                                dismiss()
                            } catch let error as DataStorageManagerError {
                                errorMessage = error.customErrorMessage
                                isShowingErrorAlert = true
                            } catch let error {
                                errorMessage = error.localizedDescription
                                isShowingErrorAlert = true
                            }
                        }
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
            .alert("Error", isPresented: $isShowingErrorAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(errorMessage)
            })
            .navigationTitle(viewModel.type.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    let modelContainer = LocalDataManager.getModelContainer()
    let dataStoreManager = DataStorageManager(modelContext: modelContainer.mainContext)
    
    SportActivityDetailView(dataStorageManager: dataStoreManager, sportActivity: nil)
}
