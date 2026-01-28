//
//  RecipediaApp.swift
//  Recipedia
//
//  Created by Johnathan Reid on 29/1/2026.
//

import SwiftUI

@main
struct RecipediaApp: App {
    @State private var recipeService = RecipeService()

    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeListViewModel(recipeService: recipeService))
        }
    }
}
