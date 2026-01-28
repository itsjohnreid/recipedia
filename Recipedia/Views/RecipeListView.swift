//
//  RecipeListView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

/// Main view displaying the list of recipes with search and filters
struct RecipeListView: View {
    @State private var viewModel: RecipeListViewModel
    @State private var showingFilters = false
    
    init(viewModel: RecipeListViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Loading State
                    ProgressView("Loading recipes...")
                        .font(.headline)
                } else if let error = viewModel.error {
                    // Error State
                    ErrorView(error: error) {
                        Task {
                            await viewModel.loadRecipes()
                        }
                    }
                } else if viewModel.filteredRecipes.isEmpty {
                    // Empty State
                    EmptyStateView(
                        hasActiveFilters: viewModel.hasActiveFilters || !viewModel.searchText.isEmpty,
                        clearFiltersAction: {
                            viewModel.clearFilters()
                            viewModel.searchText = ""
                        }
                    )
                } else {
                    // Recipe List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCardView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Recipes")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search recipes..."
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingFilters = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title3)
                            
                            // Badge for active filter count
                            if viewModel.activeFilterCount > 0 {
                                Text("\(viewModel.activeFilterCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .frame(width: 16, height: 16)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterSheetView(viewModel: viewModel)
            }
            .task {
                // Load recipes when view appears
                await viewModel.loadRecipes()
            }
        }
    }
}

#Preview("Loaded") {
    let service = RecipeService()
    let viewModel = RecipeListViewModel(recipeService: service)
    RecipeListView(viewModel: viewModel)
}

#Preview("Loading") {
    let service = RecipeService()
    let viewModel = RecipeListViewModel(recipeService: service)
    RecipeListView(viewModel: viewModel)
}
