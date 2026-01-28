//
//  EmptyStateView.swift
//  Recipedia
//
//  Created on 29/1/2026.
//

import SwiftUI

/// A view shown when no recipes match the search/filters
struct EmptyStateView: View {
    let hasActiveFilters: Bool
    let clearFiltersAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Recipes Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            if hasActiveFilters {
                Text("Try adjusting your filters to see more results")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: clearFiltersAction) {
                    Label("Clear Filters", systemImage: "xmark.circle")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
            } else {
                Text("Try a different search term")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview("Empty State - With Filters") {
    EmptyStateView(hasActiveFilters: true) {
        print("Clear filters")
    }
}

#Preview("Empty State - No Filters") {
    EmptyStateView(hasActiveFilters: false) {
        print("Clear filters")
    }
}
