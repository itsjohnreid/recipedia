//
//  RecipeService.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation

@Observable
class RecipeService {
    enum Error: LocalizedError {
        case fileNotFound
        case decodingFailed(String)
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "Could not find recipes data file."
            case .decodingFailed(let message):
                return "Failed to load recipes: \(message)"
            }
        }
    }
    
    private(set) var recipes: [Recipe] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    func loadRecipes() async {
        isLoading = true
        error = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            error = .fileNotFound
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            recipes = try decoder.decode([Recipe].self, from: data)
        } catch {
            self.error = .decodingFailed(error.localizedDescription)
        }
        
        isLoading = false
    }
}
