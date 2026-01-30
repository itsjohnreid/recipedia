//
//  RecipeDetailView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerView
                ingredientsView
                methodView
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
    
    var headerView: some View {
        section {
            Text(recipe.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(recipe.description)
                .font(.body)
                .foregroundStyle(.secondary)
            
            Label("\(recipe.servings) servings", systemImage: "person.2.fill")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            
            DietaryTagBar(dietaryAttributes: recipe.dietaryAttributes)
        }
    }
    
    var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Ingredients")
            section {
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundStyle(Color.accentColor)
                            .padding(.top, 6)
                        
                        Text(ingredient)
                            .font(.body)
                    }
                }
            }
        }
    }
    
    var methodView: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Method")
            section {
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                        
                        Text(instruction)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if index < recipe.instructions.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }
    
    func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    func section(@ViewBuilder _ content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            id: "1",
            title: "Classic Margherita Pizza",
            description: "A traditional Italian pizza with fresh mozzarella, tomatoes, and basil on a crispy thin crust.",
            servings: 4,
            ingredients: [
                "500g pizza dough",
                "200g fresh mozzarella cheese",
                "400g crushed San Marzano tomatoes",
                "3 cloves garlic, minced",
                "Fresh basil leaves",
                "2 tbsp olive oil",
                "Salt and pepper to taste"
            ],
            instructions: [
                "Preheat oven to 250°C (480°F) with a pizza stone if available.",
                "Roll out the pizza dough into a thin circle on a floured surface.",
                "Mix crushed tomatoes with minced garlic, olive oil, salt, and pepper.",
                "Spread the tomato sauce evenly over the dough, leaving a 1cm border.",
                "Tear mozzarella into pieces and distribute over the sauce.",
                "Bake for 12-15 minutes until the crust is golden and cheese is bubbly.",
                "Eat!"
            ],
            dietaryAttributes: [.vegetarian]
        ))
    }
}
