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
        
        let dateComponents = ActivityDurationConverter.getDateComponentsFromDuration(duration.wrappedValue)
        
        _selectedDay = State(initialValue: dateComponents?.day ?? 0)
        _selectedHour = State(initialValue: dateComponents?.hour ?? 0)
        _selectedMinute = State(initialValue: dateComponents?.minute ?? 0)
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
                            updateDuration()
                        }
                        
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .onChange(of: selectedHour) { _, _ in
                            updateDuration()
                        }
                        
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(minutes, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                        .onChange(of: selectedMinute) { _, _ in
                            updateDuration()
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
    func updateDuration() {
        duration = ActivityDurationConverter.getDurationFromDateComponents(day: selectedDay, hour: selectedHour, minute: selectedMinute) ?? 0.0
    }
}

#Preview {
    ActivityDurationPickerView(duration: .constant(0.0))
}
