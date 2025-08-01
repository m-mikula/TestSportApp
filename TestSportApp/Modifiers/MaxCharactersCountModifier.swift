//
//  MaxCharactersCountModifier.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftUI

fileprivate struct MaxCharactersCountModifier: ViewModifier {
    @Binding var text: String
    let maxCount: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                text = String(newValue.prefix(maxCount))
            }
    }
}

extension TextField {
    func maxCharactersCount(text: Binding<String>, maxCount: Int) -> some View {
        modifier(MaxCharactersCountModifier(text: text, maxCount: maxCount))
    }
}
