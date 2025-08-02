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
                    
                    if viewModel.type == .new {
                        DataStoragePickerView(selectedDataStorageType: $viewModel.dataStorageType)
                    } else {
                        HStack {
                            Text("Selected data storage:")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Text("\(viewModel.dataStorageType.title.uppercased())")
                                .padding(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .background(viewModel.dataStorageType.color)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.all, 12)
                        .overlay(alignment: .center, content: {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.2)
                        })
                    }
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
    SportActivityDetailView(dataStorageManager: DataStorageManager(), sportActivity: nil)
}
