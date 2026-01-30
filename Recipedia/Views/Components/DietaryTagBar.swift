//
//  DietaryTagBar.swift
//  Recipedia
//
//  Created by John Reid on 30/1/2026.
//

import SwiftUI

struct DietaryTagBar: View {
    let dietaryAttributes: [DietaryAttribute]
    
    var body: some View {
        if !dietaryAttributes.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(dietaryAttributes, id: \.self) { attribute in
                        DietaryTagView(attribute: attribute)
                    }
                }
            }
            .clipShape(Capsule())
        }
    }
}

struct DietaryTagView: View {
    let attribute: DietaryAttribute
    let font: Font
    
    init(attribute: DietaryAttribute, font: Font = .caption2) {
        self.attribute = attribute
        self.font = font
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: attribute.icon)
                .font(font)
            Text(attribute.displayName)
                .font(font)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(attribute.color.opacity(0.15))
        .foregroundStyle(attribute.color)
        .clipShape(Capsule())
    }
}

#Preview {
    DietaryTagBar(dietaryAttributes: [.dairyFree, .vegetarian, .lowCarb, .nutFree])
        .padding()
}
