//
//  RecipeListViewModel.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation

/// ViewModel for managing recipe list, search, and filtering
@Observable
class RecipeListViewModel {
    // MARK: - Properties
    
    private let recipeService: RecipeService
    
    /// Search text entered by user
    var searchText = ""
    
    /// Filter: Show only vegetarian recipes
    var showOnlyVegetarian = false
    
    /// Filter: Servings range
    var servingsFilter: ServingsFilter = .any
    
    /// Filter: Ingredients to include (comma-separated)
    var includeIngredients = ""
    
    /// Filter: Ingredients to exclude (comma-separated)
    var excludeIngredients = ""
    
    /// Filter: Search in instructions
    var instructionSearch = ""
    
    // MARK: - Servings Filter Options
    
    enum ServingsFilter: String, CaseIterable, Identifiable {
        case any = "Any"
        case single = "1-2 servings"
        case small = "3-4 servings"
        case medium = "5-6 servings"
        case large = "7+ servings"
        
        var id: String { rawValue }
        
        func matches(_ servings: Int) -> Bool {
            switch self {
            case .any: return true
            case .single: return servings >= 1 && servings <= 2
            case .small: return servings >= 3 && servings <= 4
            case .medium: return servings >= 5 && servings <= 6
            case .large: return servings >= 7
            }
        }
    }
    
    // MARK: - Computed Properties
    
    /// Filtered recipes based on all active filters
    var filteredRecipes: [Recipe] {
        let recipes = recipeService.recipes
        
        return recipes.filter { recipe in
            // Search text filter (searches in title and description)
            if !searchText.isEmpty {
                let searchLower = searchText.lowercased()
                let matchesTitle = recipe.title.lowercased().contains(searchLower)
                let matchesDescription = recipe.description.lowercased().contains(searchLower)
                if !matchesTitle && !matchesDescription {
                    return false
                }
            }
            
            // Vegetarian filter
            if showOnlyVegetarian && !recipe.hasDietaryAttribute(.vegetarian) {
                return false
            }
            
            // Servings filter
            if !servingsFilter.matches(recipe.servings) {
                return false
            }
            
            // Include ingredients filter
            if !includeIngredients.isEmpty {
                let includeList = parseIngredientList(includeIngredients)
                let hasAllIngredients = includeList.allSatisfy { ingredient in
                    recipe.ingredients.contains { recipeIngredient in
                        recipeIngredient.lowercased().contains(ingredient.lowercased())
                    }
                }
                if !hasAllIngredients {
                    return false
                }
            }
            
            // Exclude ingredients filter
            if !excludeIngredients.isEmpty {
                let excludeList = parseIngredientList(excludeIngredients)
                let hasAnyExcluded = excludeList.contains { ingredient in
                    recipe.ingredients.contains { recipeIngredient in
                        recipeIngredient.lowercased().contains(ingredient.lowercased())
                    }
                }
                if hasAnyExcluded {
                    return false
                }
            }
            
            // Instruction search filter
            if !instructionSearch.isEmpty {
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
    }
    
    /// Check if any filters are active
    var hasActiveFilters: Bool {
        showOnlyVegetarian ||
        servingsFilter != .any ||
        !includeIngredients.isEmpty ||
        !excludeIngredients.isEmpty ||
        !instructionSearch.isEmpty
    }
    
    /// Count of active filters
    var activeFilterCount: Int {
        var count = 0
        if showOnlyVegetarian { count += 1 }
        if servingsFilter != .any { count += 1 }
        if !includeIngredients.isEmpty { count += 1 }
        if !excludeIngredients.isEmpty { count += 1 }
        if !instructionSearch.isEmpty { count += 1 }
        return count
    }
    
    // MARK: - Initialization
    
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    // MARK: - Methods
    
    /// Load recipes from the service
    func loadRecipes() async {
        await recipeService.loadRecipes()
    }
    
    /// Clear all filters
    func clearFilters() {
        showOnlyVegetarian = false
        servingsFilter = .any
        includeIngredients = ""
        excludeIngredients = ""
        instructionSearch = ""
    }
    
    /// Parse comma-separated ingredient list
    private func parseIngredientList(_ text: String) -> [String] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    // MARK: - Convenience Accessors
    
    var isLoading: Bool {
        recipeService.isLoading
    }
    
    var error: RecipeService.RecipeError? {
        recipeService.error
    }
}
