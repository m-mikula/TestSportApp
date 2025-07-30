//
//  SportTextFieldView.swift
//  TestSportApp
//
//  Created by Martin Mikula on 30/07/2025.
//

import SwiftUI

struct SportTextFieldView: View {
    @Binding var text: String
    
    let placeholder: String
    let maxCount: Int
    let labelTitle: String
    let labelSystemImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(labelTitle.uppercased(), systemImage: labelSystemImage)
                .font(.caption)
                .foregroundStyle(.gray)
            
            TextField(placeholder, text: $text)
                .maxCharactersCount(text: $text, maxCount: maxCount)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable)
                .padding(.all, 12)
                .overlay(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.2)
                })
        }
    }
}

#Preview {
    SportTextFieldView(
        text: .constant(""),
        placeholder: "Running, cycling, swimming...",
        maxCount: 10,
        labelTitle: "Activity",
        labelSystemImage: "figure.run"
    )
}
