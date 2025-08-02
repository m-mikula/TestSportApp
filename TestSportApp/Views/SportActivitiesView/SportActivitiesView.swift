//
//  SportActivitiesView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

struct SportActivitiesView: View {
    @State private var isAddSportActivityViewPresented = false
    @State private var isLoadingData = false
    @StateObject private var viewModel: SportActivitiesViewModel
    private var dataStorageManager: DataStorageManager

    init(dataStorageManager: DataStorageManager) {
        self.dataStorageManager = dataStorageManager
        _viewModel = StateObject(wrappedValue: SportActivitiesViewModel(dataStorageManager: dataStorageManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                sportActivitiesListView
                
                if isLoadingData {
                    ProgressView("Loading...")
                        .frame(width: 150, height: 100)
                        .background(.gray.opacity(0.5))
                        .scaleEffect(1.7)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 2)
                }
            }
            .task {
                fetchAllData()
            }
            .searchable(text: $viewModel.searchedText, prompt: "Search activity...")
            .overlay(alignment: .center) {
                if viewModel.listSportActivities.isEmpty && isLoadingData == false {
                    Text("No activities")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
            }
            .refreshable {
                fetchAllData()
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
                        fetchAllData()
                    } content: {
                        SportActivityDetailView(dataStorageManager: dataStorageManager)
                            .interactiveDismissDisabled(true)
                    }
                }
                ToolbarItem {
                    Menu("Storage filter") {
                        ForEach(SportActivityFilterType.allCases, id: \.self) { filterType in
                            Button {
                                viewModel.selectedFilterType = filterType
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
    var sportActivitiesListView: some View {
        List {
            ForEach(viewModel.listSportActivities, id: \.id) { item in
                let storageTypeColor: Color = DataStorageType(rawValue: item.dataStorageType)?.color ?? .clear
                
                NavigationLink {
                    SportActivityDetailView(dataStorageManager: dataStorageManager, sportActivity: item)
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
            .onDelete { indexSet in
                Task {
                    try await viewModel.deleteSportActivities(offsets: indexSet)
                }
            }
        }
    }
    
    func fetchAllData() {
        Task {
            isLoadingData = true
            try await viewModel.fetchAllSportActivities()
            isLoadingData = false
        }
    }
}

#Preview {
    SportActivitiesView(dataStorageManager: DataStorageManager())
}
