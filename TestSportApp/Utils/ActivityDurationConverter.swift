//
//  ActivityDurationConverter.swift
//  TestSportApp
//
//  Created by Martin Mikula on 31/07/2025.
//

import Foundation

struct ActivityDurationConverter {
    static func getDurationFromDateComponents(day: Int, hour: Int, minute: Int) -> Double? {
        let dateComponents = DateComponents(day: day, hour: hour, minute: minute)
        let calendar = Calendar.current
        
        guard let start = calendar.date(from: dateComponents) else { return nil }
        guard let end = calendar.date(byAdding: dateComponents, to: start) else { return nil }
        
        return end.timeIntervalSince(start)
    }
    
    static func getDateComponentsFromDuration(_ duration: Double) -> DateComponents? {
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let end = start.addingTimeInterval(duration)
        
        return Calendar.current.dateComponents([.day, .hour, .minute], from: start, to: end)
    }
}
