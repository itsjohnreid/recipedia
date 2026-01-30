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
    private var hasLoadedInitially = false
    private var lastSearchQuery: RecipeService.SearchQuery?
    
    var recipes: [Recipe] = []
    var isLoading = false
    var error: RecipeError?
    
    var searchText = ""
    var selectedDietaryAttributes: Set<DietaryAttribute> = []
    var servingsFilter: ServingsFilter = .any
    var includeIngredients = ""
    var excludeIngredients = ""
    var instructionSearch = ""
        
    enum ServingsFilter: String, CaseIterable, Identifiable {
        case any = "Any"
        case single = "1-2 servings"
        case small = "3-4 servings"
        case medium = "5-6 servings"
        case large = "7+ servings"
        
        var id: String { rawValue }
        
        var range: ClosedRange<Int>? {
            switch self {
            case .any: return nil
            case .single: return 1...2
            case .small: return 3...4
            case .medium: return 5...6
            case .large: return 7...Int.max
            }
        }
    }
    
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    func loadRecipes() async {
        guard !hasLoadedInitially else { return }
        hasLoadedInitially = true
        await performSearch()
    }
    
    func performSearch() async {
        isLoading = true
        error = nil
        
        do {
            let query = buildSearchQuery()
            recipes = try await recipeService.searchRecipes(query: query)
            lastSearchQuery = query
        } catch let recipeError as RecipeError {
            self.error = recipeError
            recipes = []
        } catch {
            self.error = .loadFailed("An unexpected error occurred")
            recipes = []
        }
        
        isLoading = false
    }
    
    func applyFilters() async {
        let currentQuery = buildSearchQuery()
        guard currentQuery != lastSearchQuery else { return }
        await performSearch()
    }
    
    func clearFilters() {
        selectedDietaryAttributes.removeAll()
        servingsFilter = .any
        includeIngredients = ""
        excludeIngredients = ""
        instructionSearch = ""
    }
    
    var hasActiveFilters: Bool {
        !selectedDietaryAttributes.isEmpty ||
        servingsFilter != .any ||
        !includeIngredients.isEmpty ||
        !excludeIngredients.isEmpty ||
        !instructionSearch.isEmpty
    }
    
    var activeFilterCount: Int {
        var count = 0
        if !selectedDietaryAttributes.isEmpty { count += selectedDietaryAttributes.count }
        if servingsFilter != .any { count += 1 }
        if !includeIngredients.isEmpty { count += 1 }
        if !excludeIngredients.isEmpty { count += 1 }
        if !instructionSearch.isEmpty { count += 1 }
        return count
    }
    
    private func buildSearchQuery() -> RecipeService.SearchQuery {
        RecipeService.SearchQuery(
            searchText: searchText.isEmpty ? nil : searchText,
            dietaryAttributes: Array(selectedDietaryAttributes),
            servingsMin: servingsFilter.range?.lowerBound,
            servingsMax: servingsFilter.range?.upperBound == Int.max ? nil : servingsFilter.range?.upperBound,
            includeIngredients: parseIngredientList(includeIngredients),
            excludeIngredients: parseIngredientList(excludeIngredients),
            instructionSearch: instructionSearch.isEmpty ? nil : instructionSearch
        )
    }
    
    private func parseIngredientList(_ text: String) -> [String] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
