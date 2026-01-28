//
//  RecipeDetailView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

/// Detailed view of a single recipe
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(recipe.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    // Metadata
                    HStack(spacing: 20) {
                        MetadataItem(icon: "person.2.fill", text: "\(recipe.servings) servings")
                        MetadataItem(icon: "clock.fill", text: "\(recipe.totalTimeMinutes) min")
                        MetadataItem(icon: "timer", text: "Prep: \(recipe.prepTimeMinutes)m")
                    }
                    .font(.subheadline)
                    
                    // Dietary Attributes
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
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Ingredients Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "Ingredients", icon: "list.bullet")
                    
                    VStack(alignment: .leading, spacing: 12) {
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
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Instructions Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "Instructions", icon: "list.number")
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                                
                                Text(instruction)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// A reusable metadata item view
struct MetadataItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        Label(text, systemImage: icon)
            .foregroundStyle(.secondary)
    }
}

/// A reusable section header
struct SectionHeaderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
        }
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
                "Bake for 12-15 minutes until the crust is golden and cheese is bubbly."
            ],
            dietary: [.vegetarian],
            prepTimeMinutes: 20,
            cookTimeMinutes: 15,
            imageURL: nil
        ))
    }
}
