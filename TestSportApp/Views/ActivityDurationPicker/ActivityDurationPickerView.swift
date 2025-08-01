//
//  ActivityDurationPickerView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

struct ActivityDurationPickerView: View {
    @StateObject var viewModel: ActivityDurationPickerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Duration".uppercased(), systemImage: "stopwatch")
                .font(.caption)
                .foregroundStyle(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Selected duration: ")
                    Spacer()
                    Text("\(viewModel.selectedDay) d \(viewModel.selectedHour) h \(viewModel.selectedMinute) m")
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
                
                HStack {
                    Group {
                        Picker("Day", selection: $viewModel.selectedDay) {
                            ForEach(viewModel.days, id: \.self) { day in
                                Text("\(day)")
                            }
                        }
                        .onChange(of: viewModel.selectedDay) { _, _ in
                            viewModel.updateDuration()
                        }
                        
                        Picker("Hour", selection: $viewModel.selectedHour) {
                            ForEach(viewModel.hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .onChange(of: viewModel.selectedHour) { _, _ in
                            viewModel.updateDuration()
                        }
                        
                        Picker("Minute", selection: $viewModel.selectedMinute) {
                            ForEach(viewModel.minutes, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                        .onChange(of: viewModel.selectedMinute) { _, _ in
                            viewModel.updateDuration()
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

#Preview {
    ActivityDurationPickerView(viewModel: ActivityDurationPickerViewModel(duration: .constant(2.0)))
}
