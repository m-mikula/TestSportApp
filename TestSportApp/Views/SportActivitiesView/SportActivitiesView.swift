//
//  SportActivitiesView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

struct SportActivitiesView: View {
    @State private var isAddSportActivityViewPresented = false
    @State private var searchedText = ""
    
    @StateObject var viewModel: SportActivitiesViewModel

    var body: some View {
        NavigationStack {
            List { 
                ForEach(filteredSportActivities, id: \.id) { item in
                    let storageTypeColor: Color = DataStorageType(rawValue: item.dataStorageType)?.color ?? .clear
                    
                    NavigationLink {
                        SportActivityDetailView(viewModel: SportActivityDetailViewModel(modelContext: viewModel.modelContext, sportActivity: item))
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
            .searchable(text: $searchedText, prompt: "Search activity...")
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
                        SportActivityDetailView(viewModel: SportActivityDetailViewModel(modelContext: viewModel.modelContext))
                            .interactiveDismissDisabled(true)
                    }

                }
                ToolbarItem {
                    Menu("Storage filter") {
                        ForEach(SportActivityFilterType.allCases, id: \.self) { filterType in
                            Button {
                                viewModel.filterSportActivities(by: filterType)
                            } label: {
                                if viewModel.selectedFilterType == filterType {
                                    Label(filterType.title, systemImage: "checkmark")
                                } else {
                                    Text(filterType.title)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private extension SportActivitiesView {
    var filteredSportActivities: [SportActivity] {
        if searchedText.isEmpty {
            return viewModel.sportActivities
        } else {
            return viewModel.sportActivities.filter { $0.activity.localizedStandardContains(searchedText) }
        }
    }
}

#Preview {
    let modelContainer = LocalDataManager.getModelContainer()
    
    SportActivitiesView(viewModel: SportActivitiesViewModel(modelContext: modelContainer.mainContext))
}
