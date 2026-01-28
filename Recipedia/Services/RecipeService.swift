//
//  RecipeService.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import Foundation

/// Service responsible for loading and managing recipe data
@Observable
class RecipeService {
    /// Current state of the service
    enum LoadingState {
        case idle
        case loading
        case loaded([Recipe])
        case error(RecipeError)
    }
    
    /// Errors that can occur during recipe loading
    enum RecipeError: LocalizedError {
        case fileNotFound
        case invalidData
        case decodingFailed(String)
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "Could not find recipes data file."
            case .invalidData:
                return "The recipes data is invalid or corrupted."
            case .decodingFailed(let message):
                return "Failed to decode recipes: \(message)"
            }
        }
    }
    
    private(set) var state: LoadingState = .idle
    
    /// Computed property to easily access loaded recipes
    var recipes: [Recipe] {
        if case .loaded(let recipes) = state {
            return recipes
        }
        return []
    }
    
    /// Computed property to check if currently loading
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    /// Computed property to get current error if any
    var error: RecipeError? {
        if case .error(let error) = state {
            return error
        }
        return nil
    }
    
    /// Load recipes from the bundled JSON file
    func loadRecipes() async {
        state = .loading
        
        // Simulate network delay for realistic API behavior
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            state = .error(.fileNotFound)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let recipes = try decoder.decode([Recipe].self, from: data)
            state = .loaded(recipes)
        } catch let error as DecodingError {
            let message = formatDecodingError(error)
            state = .error(.decodingFailed(message))
        } catch {
            state = .error(.invalidData)
        }
    }
    
    /// Format decoding error for better user feedback
    private func formatDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, _):
            return "Missing key: \(key.stringValue)"
        case .typeMismatch(let type, let context):
            return "Type mismatch for type \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .valueNotFound(let type, let context):
            return "Missing value for type \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .dataCorrupted(let context):
            return "Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        @unknown default:
            return "Unknown decoding error"
        }
    }
}
