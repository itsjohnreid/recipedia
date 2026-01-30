//
//  RecipeService.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation

enum RecipeError: LocalizedError {
    case loadFailed(String)
    case decodingFailed
    case noData
    
    var errorDescription: String? {
        switch self {
        case .loadFailed(let message):
            return message
        case .decodingFailed:
            return "Failed to load recipe data"
        case .noData:
            return "No recipe data available"
        }
    }
}

class RecipeService {
    /// Search recipes using the mock API endpoint
    func searchRecipes(query: SearchQuery) async throws -> [Recipe] {
        do {
            let response = try await MockRecipeAPI.searchRecipes(query: query)
            return response.recipes
        } catch let error as MockRecipeAPI.APIError {
            throw RecipeError.loadFailed(error.localizedDescription)
        } catch {
            throw RecipeError.loadFailed("Unable to load recipes")
        }
    }
}

extension RecipeService {
    struct SearchQuery: Equatable {
        var searchText: String?
        var dietaryAttributes: [DietaryAttribute]
        var servingsMin: Int?
        var servingsMax: Int?
        var includeIngredients: [String]
        var excludeIngredients: [String]
        var instructionSearch: String?
        
        init(
            searchText: String? = nil,
            dietaryAttributes: [DietaryAttribute] = [],
            servingsMin: Int? = nil,
            servingsMax: Int? = nil,
            includeIngredients: [String] = [],
            excludeIngredients: [String] = [],
            instructionSearch: String? = nil
        ) {
            self.searchText = searchText
            self.dietaryAttributes = dietaryAttributes
            self.servingsMin = servingsMin
            self.servingsMax = servingsMax
            self.includeIngredients = includeIngredients
            self.excludeIngredients = excludeIngredients
            self.instructionSearch = instructionSearch
        }
    }
}
