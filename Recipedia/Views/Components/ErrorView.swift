//
//  ErrorView.swift
//  Recipedia
//
//  Created on 30/1/2026.
//

import SwiftUI

struct ErrorView: View {
    let error: LocalizedError
    let retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("Error", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(error.localizedDescription)
        } actions: {
            Button("Try Again", action: retryAction)
        }
    }
}

#Preview {
    ErrorView(error: RecipeError.loadFailed("Could not load recipes")) {
        print("Retry tapped")
    }
}
