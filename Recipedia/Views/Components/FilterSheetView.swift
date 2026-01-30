//
//  FilterSheetView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

struct FilterSheetView: View {
    @Bindable var viewModel: RecipeListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                dietaryAttributesSection
                servingsSection
                ingredientsSections
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .destructive) {
                        viewModel.clearFilters()
                    } label: {
                        Text("Clear")
                    }
                    .disabled(!viewModel.hasActiveFilters)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.applyFilters()
                        }
                        dismiss()
                    }
                }
            }
        }
    }
    
    var dietaryAttributesSection: some View {
        Section("Dietary Attributes") {
            ForEach(DietaryAttribute.allCases, id: \.self) { attribute in
                Toggle(
                    isOn: Binding(
                        get: { viewModel.selectedDietaryAttributes.contains(attribute) },
                        set: { isSelected in
                            if isSelected {
                                viewModel.selectedDietaryAttributes.insert(attribute)
                            } else {
                                viewModel.selectedDietaryAttributes.remove(attribute)
                            }
                        }
                    )
                ) {
                    DietaryTagView(attribute: attribute, font: .footnote)
                }
                .tint(.accentColor)
            }
        }
    }
    
    var servingsSection: some View {
        Section("Servings") {
            Picker("Number of Servings", selection: $viewModel.servingsFilter) {
                ForEach(RecipeListViewModel.ServingsFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    @ViewBuilder
    var ingredientsSections: some View {
        Section {
            TextField("e.g., garlic, tomatoes", text: $viewModel.includeIngredients)
                .autocapitalization(.none)
        } header: {
            Text("Include Ingredients")
        }
        
        Section {
            TextField("e.g., nuts, dairy", text: $viewModel.excludeIngredients)
                .autocapitalization(.none)
        } header: {
            Text("Exclude Ingredients")
        }
        
        Section {
            TextField("Search in cooking steps", text: $viewModel.instructionSearch)
                .autocapitalization(.none)
        } header: {
            Text("Instructions Search")
        }
    }
}

#Preview {
    FilterSheetView(viewModel: RecipeListViewModel(recipeService: RecipeService()))
}
