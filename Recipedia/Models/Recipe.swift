//
//  Recipe.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation
import SwiftUI

struct Recipe: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let servings: Int
    let ingredients: [String]
    let instructions: [String]
    let dietaryAttributes: [DietaryAttribute]
}

enum DietaryAttribute: String, Codable, CaseIterable {
    case vegetarian
    case vegan
    case glutenFree
    case dairyFree
    case nutFree
    case lowCarb
    
    var displayName: String {
        switch self {
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .glutenFree: return "Gluten Free"
        case .dairyFree: return "Dairy Free"
        case .nutFree: return "Nut Free"
        case .lowCarb: return "Low Carb"
        }
    }
    
    var icon: String {
        switch self {
        case .vegetarian: return "leaf.fill"
        case .vegan: return "leaf.circle.fill"
        case .glutenFree: return "g.circle.fill"
        case .dairyFree: return "drop.fill"
        case .nutFree: return "n.circle.fill"
        case .lowCarb: return "c.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .vegetarian: return .green
        case .vegan: return .mint
        case .glutenFree: return .orange
        case .dairyFree: return .blue
        case .nutFree: return .brown
        case .lowCarb: return .purple
        }
    }
}
