//
//  RecipeCardView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

/// A card view displaying a recipe summary
struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
            
            // Description
            Text(recipe.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
            
            // Metadata row
            HStack(spacing: 16) {
                // Servings
                Label("\(recipe.servings)", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                // Time
                Label("\(recipe.totalTimeMinutes) min", systemImage: "clock.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Dietary attributes
            if !recipe.dietary.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(recipe.dietary, id: \.self) { attribute in
                            DietaryTagView(attribute: attribute)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

/// A small tag showing a dietary attribute
struct DietaryTagView: View {
    let attribute: DietaryAttribute
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: attribute.icon)
                .font(.caption2)
            Text(attribute.displayName)
                .font(.caption2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.accentColor.opacity(0.1))
        .foregroundStyle(Color.accentColor)
        .cornerRadius(6)
    }
}

#Preview("Recipe Card") {
    RecipeCardView(recipe: Recipe(
        id: "1",
        title: "Classic Margherita Pizza",
        description: "A traditional Italian pizza with fresh mozzarella, tomatoes, and basil on a crispy thin crust.",
        servings: 4,
        ingredients: ["Pizza dough", "Mozzarella", "Tomatoes", "Basil"],
        instructions: ["Make dough", "Add toppings", "Bake"],
        dietary: [.vegetarian],
        prepTimeMinutes: 20,
        cookTimeMinutes: 15,
        imageURL: nil
    ))
    .padding()
}
