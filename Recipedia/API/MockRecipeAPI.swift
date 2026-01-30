//
//  MockRecipeAPI.swift
//  Recipedia
//
//  Created on 30/1/2026.
//

import Foundation

/// Mock API that simulates a backend recipe search endpoint
struct MockRecipeAPI {
    
    struct SearchResponse: Codable {
        let recipes: [Recipe]
        let totalCount: Int
    }
    
    enum APIError: Error, LocalizedError {
        case dataNotFound
        case decodingFailed
        case invalidQuery
        
        var errorDescription: String? {
            switch self {
            case .dataNotFound:
                return "Recipe data not found"
            case .decodingFailed:
                return "Failed to decode recipe data"
            case .invalidQuery:
                return "Invalid search query"
            }
        }
    }
    
    /// Simulates a backend search endpoint
    /// - Parameter query: The search query with filters
    /// - Returns: Filtered recipes matching the query
    static func searchRecipes(query: RecipeService.SearchQuery) async throws -> SearchResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Load data from bundle
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            throw APIError.dataNotFound
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let allRecipes = try decoder.decode([Recipe].self, from: data)
        
        // Apply filters (simulating backend filtering)
        let filteredRecipes = allRecipes.filter { recipe in
            // Search text filter
            if let searchText = query.searchText, !searchText.isEmpty {
                let searchLower = searchText.lowercased()
                let matchesTitle = recipe.title.lowercased().contains(searchLower)
                let matchesDescription = recipe.description.lowercased().contains(searchLower)
                if !matchesTitle && !matchesDescription {
                    return false
                }
            }
            
            // Dietary attributes filter (must have ALL selected attributes)
            if !query.dietaryAttributes.isEmpty {
                let hasAllAttributes = query.dietaryAttributes.allSatisfy { attribute in
                    recipe.dietaryAttributes.contains(attribute)
                }
                if !hasAllAttributes {
                    return false
                }
            }
            
            // Servings range filter
            if let minServings = query.servingsMin, recipe.servings < minServings {
                return false
            }
            if let maxServings = query.servingsMax, recipe.servings > maxServings {
                return false
            }
            
            // Include ingredients filter (must have ALL)
            if !query.includeIngredients.isEmpty {
                let hasAllIngredients = query.includeIngredients.allSatisfy { ingredient in
                    recipe.ingredients.contains { recipeIngredient in
                        recipeIngredient.lowercased().contains(ingredient.lowercased())
                    }
                }
                if !hasAllIngredients {
                    return false
                }
            }
            
            // Exclude ingredients filter (must have NONE)
            if !query.excludeIngredients.isEmpty {
                let hasAnyExcluded = query.excludeIngredients.contains { ingredient in
                    recipe.ingredients.contains { recipeIngredient in
                        recipeIngredient.lowercased().contains(ingredient.lowercased())
                    }
                }
                if hasAnyExcluded {
                    return false
                }
            }
            
            // Instruction search filter
            if let instructionSearch = query.instructionSearch, !instructionSearch.isEmpty {
                let searchLower = instructionSearch.lowercased()
                let matchesAnyInstruction = recipe.instructions.contains { instruction in
                    instruction.lowercased().contains(searchLower)
                }
                if !matchesAnyInstruction {
                    return false
                }
            }
            
            return true
        }
        
        return SearchResponse(
            recipes: filteredRecipes,
            totalCount: filteredRecipes.count
        )
    }
}
