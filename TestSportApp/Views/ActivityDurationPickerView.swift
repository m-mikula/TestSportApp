//
//  ActivityDurationPickerView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

struct ActivityDurationPickerView: View {
    @Binding private var duration: Double
    
    @State private var selectedDay: Int = 0
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    
    private let days = [Int](0..<100)
    private let hours = [Int](0..<24)
    private let minutes = [Int](0..<60)
    
    init(duration: Binding<Double>) {
        _duration = duration
        
        let dateComponents = getDateComponentsFromDuration(duration.wrappedValue)
        
        selectedDay = dateComponents?.day ?? 0
        selectedHour = dateComponents?.hour ?? 0
        selectedMinute = dateComponents?.minute ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Duration".uppercased(), systemImage: "stopwatch")
                .font(.caption)
                .foregroundStyle(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Selected duration: ")
                    Spacer()
                    Text("\(selectedDay) d \(selectedHour) h \(selectedMinute) m")
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
                
                HStack {
                    Group {
                        Picker("Day", selection: $selectedDay) {
                            ForEach(days, id: \.self) { day in
                                Text("\(day)")
                            }
                        }
                        .onChange(of: selectedDay) { _, _ in
                            duration = getDurationFromDateComponents() ?? 0.0
                        }
                        
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .onChange(of: selectedHour) { _, _ in
                            duration = getDurationFromDateComponents() ?? 0.0
                        }
                        
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(minutes, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                        .onChange(of: selectedMinute) { _, _ in
                            duration = getDurationFromDateComponents() ?? 0.0
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .padding(.all, 12)
            .overlay(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0.2)
            })
        }
    }
}

private extension ActivityDurationPickerView {
    func getDurationFromDateComponents() -> Double? {
        let dateComponents = DateComponents(day: selectedDay, hour: selectedHour, minute: selectedMinute)
        let calendar = Calendar.current
        
        guard let start = calendar.date(from: dateComponents) else { return nil }
        guard let end = calendar.date(byAdding: dateComponents, to: start) else { return nil }
        
        return end.timeIntervalSince(start)
    }
    
    func getDateComponentsFromDuration(_ duration: Double) -> DateComponents? {
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let end = start.addingTimeInterval(duration)
        
        return Calendar.current.dateComponents([.day, .hour, .minute], from: start, to: end)
    }
}


#Preview {
    ActivityDurationPickerView(duration: .constant(0.0))
}
