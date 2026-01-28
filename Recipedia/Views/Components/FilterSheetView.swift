//
//  FilterSheetView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

/// A sheet view for displaying all filter options
struct FilterSheetView: View {
    @Bindable var viewModel: RecipeListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Dietary Section
                Section("Dietary Preferences") {
                    Toggle("Vegetarian Only", isOn: $viewModel.showOnlyVegetarian)
                }
                
                // Servings Section
                Section("Servings") {
                    Picker("Number of Servings", selection: $viewModel.servingsFilter) {
                        ForEach(RecipeListViewModel.ServingsFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Ingredients Section
                Section {
                    TextField("e.g., garlic, tomatoes", text: $viewModel.includeIngredients)
                        .autocapitalization(.none)
                    
                    Text("Comma-separated ingredients that must be included")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Include Ingredients")
                }
                
                Section {
                    TextField("e.g., nuts, dairy", text: $viewModel.excludeIngredients)
                        .autocapitalization(.none)
                    
                    Text("Comma-separated ingredients to exclude")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Exclude Ingredients")
                }
                
                // Instructions Section
                Section {
                    TextField("Search in cooking steps", text: $viewModel.instructionSearch)
                        .autocapitalization(.none)
                    
                    Text("Find recipes with specific cooking techniques")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Instructions Search")
                }
                
                // Clear Filters
                if viewModel.hasActiveFilters {
                    Section {
                        Button(role: .destructive, action: {
                            viewModel.clearFilters()
                        }) {
                            Label("Clear All Filters", systemImage: "xmark.circle.fill")
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterSheetView(viewModel: RecipeListViewModel(recipeService: RecipeService()))
}
