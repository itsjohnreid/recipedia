//
//  RecipeListViewModel.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation

@Observable
class RecipeListViewModel {
    private let recipeService: RecipeService
    
    var searchText = ""
    
    var selectedDietaryAttributes: Set<DietaryAttribute> = []
    
    var servingsFilter: ServingsFilter = .any
    
    var includeIngredients = ""
    
    var excludeIngredients = ""
        
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
    
    
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    var filteredRecipes: [Recipe] {
        let recipes = recipeService.recipes
        
        return recipes.filter { recipe in
            if !searchText.isEmpty {
                let searchLower = searchText.lowercased()
                let matchesTitle = recipe.title.lowercased().contains(searchLower)
                let matchesDescription = recipe.description.lowercased().contains(searchLower)
                if !matchesTitle && !matchesDescription {
                    return false
                }
            }
            
            if !selectedDietaryAttributes.isEmpty {
                let hasAllAttributes = selectedDietaryAttributes.allSatisfy { attribute in
                    recipe.dietaryAttributes.contains(attribute)
                }
                if !hasAllAttributes {
                    return false
                }
            }
            
            if !servingsFilter.matches(recipe.servings) {
                return false
            }
            
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
            
            return true
        }
    }
    
    var hasActiveFilters: Bool {
        !selectedDietaryAttributes.isEmpty ||
        servingsFilter != .any ||
        !includeIngredients.isEmpty ||
        !excludeIngredients.isEmpty
    }
    
    var activeFilterCount: Int {
        var count = 0
        if !selectedDietaryAttributes.isEmpty { count += selectedDietaryAttributes.count }
        if servingsFilter != .any { count += 1 }
        if !includeIngredients.isEmpty { count += 1 }
        if !excludeIngredients.isEmpty { count += 1 }
        return count
    }
        
    func loadRecipes() async {
        await recipeService.loadRecipes()
    }
    
    func clearFilters() {
        selectedDietaryAttributes.removeAll()
        servingsFilter = .any
        includeIngredients = ""
        excludeIngredients = ""
    }
    
    private func parseIngredientList(_ text: String) -> [String] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
        
    var isLoading: Bool {
        recipeService.isLoading
    }
    
    var error: RecipeService.Error? {
        recipeService.error
    }
}
