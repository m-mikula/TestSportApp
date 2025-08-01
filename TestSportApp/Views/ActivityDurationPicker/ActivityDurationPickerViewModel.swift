//
//  ActivityDurationPickerViewModel.swift
//  TestSportApp
//
//  Created by Martin Mikula on 01/08/2025.
//

import SwiftUI

final class ActivityDurationPickerViewModel: ObservableObject {
    @Binding private(set) var duration: Double
    
    @Published var selectedDay: Int = 0
    @Published var selectedHour: Int = 0
    @Published var selectedMinute: Int = 0
    
    let days = [Int](0..<100)
    let hours = [Int](0..<24)
    let minutes = [Int](0..<60)
    
    init(duration: Binding<Double>) {
        _duration = duration
        
        let dateComponents = ActivityDurationConverter.getDateComponentsFromDuration(duration.wrappedValue)
        
        selectedDay = dateComponents?.day ?? 0
        selectedHour = dateComponents?.hour ?? 0
        selectedMinute = dateComponents?.minute ?? 0
    }
    
    func updateDuration() {
        duration = ActivityDurationConverter.getDurationFromDateComponents(day: selectedDay, hour: selectedHour, minute: selectedMinute) ?? 0.0
    }
}
