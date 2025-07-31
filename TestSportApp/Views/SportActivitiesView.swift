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
        NavigationStack {
            List {
                ForEach(viewModel.sportActivities, id: \.id) { item in
                    let storageTypeColor: Color = DataStorageType(rawValue: item.dataStorageType)?.color ?? .clear
                    
                    NavigationLink {
                        SportActivityDetailView(modelContext: modelContext, sportActivity: item)
                    } label: {
                        let duration = ActivityDurationConverter.getDateComponentsFromDuration(item.duration)
                        
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: 8)
                                .foregroundStyle(storageTypeColor)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.activity)
                                    .font(.headline)
                                Text(item.location)
                                Text("\(duration?.day ?? 0) d \(duration?.hour ?? 0) h \(duration?.minute ?? 0) m")
                            }
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
                    Button {
                        isAddSportActivityViewPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddSportActivityViewPresented) {
                        viewModel.fetchAllSportActivities()
                    } content: {
                        SportActivityDetailView(modelContext: modelContext)
                            .interactiveDismissDisabled(true)
                    }

                }
                ToolbarItem {
                    Menu("Storage filter") {
                        ForEach(DataStorageType.allCases, id: \.self) { dataStorageType in
                            Button {
                                viewModel.filterSportActivities(by: dataStorageType)
                            } label: {
                                if viewModel.selectedDataStorageType == dataStorageType {
                                    Label(dataStorageType.title, systemImage: "checkmark")
                                } else {
                                    Text(dataStorageType.title)
                                }
                            }
                        }
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
