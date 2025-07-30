//
//  SportActivitiesView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftData
import SwiftUI

struct SportActivitiesView: View {
    @State private var isAddSportActivityViewPresented = false
    
    private var modelContext: ModelContext
    @StateObject private var viewModel: SportActivitiesViewModel
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: SportActivitiesViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sportActivities, id: \.id) { item in
                    NavigationLink {
                        Text("Detail name: \(item.activity)")
                        // TODO: navvigate to detail
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.activity)
                            Text(item.location)
                            Text("Duration: \(item.duration)")
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteSportActivities)
            }
            .overlay(alignment: .center) {
                if viewModel.sportActivities.isEmpty {
                    Text("No activities")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
            }
            .refreshable {
                viewModel.fetchAllSportActivities()
            }
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        isAddSportActivityViewPresented.toggle()
                    }
                    .sheet(isPresented: $isAddSportActivityViewPresented) {
                        viewModel.fetchAllSportActivities()
                    } content: {
                        AddSportActivityView(modelContext: modelContext)
                            .interactiveDismissDisabled(true)
                    }

                }
            }
        }
    }
}

#Preview {
    let modelContainer = LocalDataManager.getModelContainer()
    
    SportActivitiesView(modelContext: modelContainer.mainContext)
}
