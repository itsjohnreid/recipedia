//
//  RecipeListView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

struct RecipeListView: View {
    @State private var viewModel: RecipeListViewModel
    @State private var isPresentedFilterMenu = false
    
    init(viewModel: RecipeListViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                } else if let error = viewModel.error {
                    errorView(error: error)
                } else if viewModel.filteredRecipes.isEmpty {
                    emptyView
                } else {
                    listView
                }
            }
            .navigationTitle("Recipedia")
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search recipes..."
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentedFilterMenu = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            if viewModel.activeFilterCount > 0 {
                                Text("\(viewModel.activeFilterCount)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .frame(width: 16, height: 16)
                                    .background(Color.accent)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentedFilterMenu) {
                FilterSheetView(viewModel: viewModel)
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    func errorView(error: RecipeService.Error) -> some View {
        ErrorView(error: error) {
            Task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    var emptyView: some View {
        ContentUnavailableView(
            "No Recipes Found",
            systemImage: "magnifyingglass",
            description: Text("Try adjusting your filters")
        )
    }
    
    var listView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.filteredRecipes) { recipe in
                    RecipeCardView(recipe: recipe)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    let service = RecipeService()
    let viewModel = RecipeListViewModel(recipeService: service)
    RecipeListView(viewModel: viewModel)
}
