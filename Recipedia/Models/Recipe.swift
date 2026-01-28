//
//  Recipe.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation

/// Represents a cooking recipe with all its details
struct Recipe: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let servings: Int
    let ingredients: [String]
    let instructions: [String]
    let dietary: [DietaryAttribute]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let imageURL: String?
    
    /// Total time required to prepare and cook the recipe
    var totalTimeMinutes: Int {
        prepTimeMinutes + cookTimeMinutes
    }
    
    /// Check if recipe matches dietary requirements
    func hasDietaryAttribute(_ attribute: DietaryAttribute) -> Bool {
        dietary.contains(attribute)
    }
}

/// Dietary attributes for recipes
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
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .nutFree: return "Nut-Free"
        case .lowCarb: return "Low-Carb"
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
}
