//
//  RecipeCardView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(recipe.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                
                Text(recipe.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                HStack(spacing: 16) {
                    Label("\(recipe.servings)", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                DietaryTagBar(dietaryAttributes: recipe.dietaryAttributes)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Recipe Card") {
    NavigationStack {
        RecipeCardView(recipe: Recipe(
            id: "1",
            title: "Classic Margherita Pizza",
            description: "A traditional Italian pizza with fresh mozzarella, tomatoes, and basil on a crispy thin crust.",
            servings: 4,
            ingredients: ["Pizza dough", "Mozzarella", "Tomatoes", "Basil"],
            instructions: ["Make dough", "Add toppings", "Bake"],
            dietaryAttributes: [.vegetarian]
        ))
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
