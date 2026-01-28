# 📘 Recipedia

A native iOS application built with **Swift** and **SwiftUI** that allows users to browse, search, and filter a collection of cooking recipes.

## 🚀 Features

- **Browse Recipes**: View a curated collection of 15 recipes with detailed information
- **Advanced Search**: Search recipes by title and description in real-time
- **Powerful Filtering**:
  - Filter by dietary preferences (vegetarian, vegan, gluten-free, etc.)
  - Filter by serving size ranges
  - Include/exclude specific ingredients
  - Search within cooking instructions
- **Clean UI**: Intuitive card-based interface with detailed recipe views
- **Real-time Updates**: Filters and search update instantly using SwiftUI's reactive framework
- **Error Handling**: Graceful error states with retry functionality

## 📋 Requirements

- **Xcode**: 15.0 or later
- **iOS**: 17.0 or later (for @Observable macro support)
- **Swift**: 5.9 or later

## 🛠️ Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd recipedia
   ```

2. **Open the project**:
   ```bash
   open Recipedia.xcodeproj
   ```

3. **Build and run**:
   - Select a simulator or connected device from the Xcode toolbar
   - Press `Cmd + R` to build and run the app
   - The app will load recipes from the bundled `recipes.json` file

4. **Running on a physical device**:
   - Update the Development Team in project settings
   - Connect your iOS device
   - Select your device and run

## 🏗️ Architecture Overview

The application follows the **MVVM (Model-View-ViewModel)** architecture pattern with Swift's modern **@Observable** macro for reactive state management.

### Project Structure

```
Recipedia/
├── Models/
│   └── Recipe.swift              # Recipe data model with DietaryAttribute enum
├── Services/
│   └── RecipeService.swift       # Data loading service with error handling
├── ViewModels/
│   └── RecipeListViewModel.swift # Business logic for search/filtering
├── Views/
│   ├── RecipeListView.swift      # Main list view with search
│   ├── RecipeDetailView.swift    # Detailed recipe view
│   └── Components/
│       ├── RecipeCardView.swift  # Recipe card component
│       ├── FilterSheetView.swift # Filter UI sheet
│       ├── ErrorView.swift       # Error state view
│       └── EmptyStateView.swift  # Empty results view
├── Resources/
│   └── recipes.json              # Mock API data
├── ContentView.swift             # App entry point
└── RecipediaApp.swift            # App configuration
```

### Data Flow

1. **RecipeService** loads recipe data from `recipes.json` (simulating API call with delay)
2. **RecipeListViewModel** manages search state, filter state, and computed filtered results
3. **Views** observe the ViewModel using `@Observable` and automatically update on state changes
4. User interactions trigger ViewModel methods, which update state and trigger UI updates

### Key Components

#### Models
- **Recipe**: Codable struct representing a recipe with all attributes
- **DietaryAttribute**: Enum for dietary tags (vegetarian, vegan, gluten-free, etc.)

#### Services
- **RecipeService** (`@Observable`):
  - Loads and parses JSON data
  - Manages loading states (idle, loading, loaded, error)
  - Provides error handling for file operations and decoding

#### ViewModels
- **RecipeListViewModel** (`@Observable`):
  - Manages search text and all filter parameters
  - Computes filtered recipes using AND logic
  - Provides helper methods for filter management
  - Exposes loading and error states from RecipeService

#### Views
- **RecipeListView**: Main interface with search bar, filter button, and recipe cards
- **RecipeDetailView**: Full recipe details with ingredients and instructions
- **FilterSheetView**: Modal sheet for advanced filtering options
- **Component Views**: Reusable UI components for cards, errors, and empty states

## 🔍 Search & Filter Implementation

### Search Algorithm
- **Case-insensitive substring matching** on recipe title and description
- Real-time filtering as user types
- Uses SwiftUI's native `.searchable()` modifier

### Filter Logic
All active filters use **AND logic** - a recipe must satisfy ALL active filters to appear in results:

1. **Vegetarian Filter**: Checks if recipe has `.vegetarian` dietary attribute
2. **Servings Filter**: Range-based matching (1-2, 3-4, 5-6, 7+)
3. **Include Ingredients**: Recipe must contain ALL specified ingredients (comma-separated)
4. **Exclude Ingredients**: Recipe must NOT contain ANY specified ingredients
5. **Instruction Search**: Case-insensitive substring search across all instruction steps

### Performance
- Computed properties re-calculate only when dependencies change
- Lazy loading of recipe cards in ScrollView
- Minimal re-renders thanks to SwiftUI's efficient diffing

## 🎨 Design Decisions

### 1. Modern SwiftUI with @Observable
- Uses Swift 5.9's `@Observable` macro instead of `ObservableObject`
- Eliminates boilerplate (`@Published`, `ObservableObject` conformance)
- More efficient - only views using specific properties re-render
- Cleaner syntax with `@Bindable` for two-way bindings

### 2. Native SwiftUI Components
- No external dependencies - uses only native frameworks
- `.searchable()` for search functionality
- Native `NavigationStack` for navigation
- SF Symbols for consistent iconography

### 3. Service Layer Architecture
- RecipeService simulates API behavior (0.5s delay)
- Easy to swap JSON loading for real network calls
- Centralized error handling
- State machine pattern for loading states

### 4. Comprehensive Error Handling
- User-facing error messages
- Retry functionality for failed loads
- Detailed decoding error messages for debugging
- Empty state guidance for no results

### 5. Component Reusability
- Small, focused components (RecipeCardView, DietaryTagView, etc.)
- SwiftUI Previews for each component
- Consistent styling and spacing

### 6. Filter UX
- Modal sheet prevents accidental filter changes
- Visual badge showing active filter count
- Quick "Clear All Filters" button
- Real-time preview of filter results

## 📝 Assumptions & Tradeoffs

### Assumptions
1. **Data Source**: Recipes are loaded from a static JSON file bundled with the app
2. **Image Support**: Recipe image URLs are optional and not currently displayed (infrastructure ready for future implementation)
3. **Search Scope**: Search only covers title and description, not ingredients (to avoid over-matching)
4. **Filter Combination**: All filters use AND logic - this may be restrictive but provides predictable results
5. **Ingredient Matching**: Simple substring matching (case-insensitive) - not fuzzy matching or lemmatization
6. **iOS Version**: Requires iOS 17+ for `@Observable` - excludes users on iOS 16 and below

### Tradeoffs

#### ✅ Pros of Current Approach
- **Simple & Maintainable**: Clear architecture, easy to understand
- **Fast Development**: Native components, no dependency management
- **Performance**: Efficient reactive updates, lazy loading
- **Testable**: Clear separation of concerns, pure functions for filtering
- **Modern**: Uses latest Swift features (@Observable, async/await)

#### ⚠️ Cons & Limitations
- **No Persistence**: Filters and search don't persist across app launches
- **Limited Search**: No fuzzy matching or typo tolerance
- **Static Data**: No ability to add/edit recipes from the app
- **No Images**: Recipe images not displayed (URLs supported but no rendering)
- **iOS 17+ Only**: Older iOS versions not supported due to @Observable requirement
- **No Favorites**: No way to bookmark or save favorite recipes
- **No Sharing**: Can't share recipes with others

### Future Enhancements
1. **Remote API Integration**: Replace JSON loading with real network calls
2. **Image Display**: Show recipe images using AsyncImage
3. **Favorites System**: Allow users to bookmark recipes (local storage)
4. **Recipe Editing**: Add, edit, and delete recipes
5. **Advanced Search**: Fuzzy matching, search suggestions, recent searches
6. **Filter Presets**: Save common filter combinations
7. **Ingredient Substitutions**: Suggest alternatives for ingredients
8. **Shopping List**: Generate shopping list from selected recipes
9. **Nutrition Info**: Add calorie and macro information
10. **Social Features**: Recipe ratings, reviews, and sharing

## 🧪 Testing

The project includes:
- **SwiftUI Previews**: All views have preview configurations for rapid iteration
- **Unit Test Structure**: Test targets ready for implementation
- **UI Test Structure**: UI test targets configured

To add tests:
1. Open `RecipediaTests/RecipediaTests.swift` for unit tests
2. Open `RecipediaUITests/RecipediaUITests.swift` for UI tests
3. Use `Cmd + U` to run all tests

## 🐛 Known Limitations

1. **No Offline Indicator**: If JSON fails to load, error may not clearly indicate it's a local file issue
2. **No Loading Progress**: Loading state is binary (loading/loaded) - no progress percentage
3. **Filter Reset on Navigation**: Filters remain active when viewing detail and returning
4. **No Search History**: Previous searches are not saved or suggested
5. **Ingredient Parsing**: Comma-separated parsing is simple and doesn't handle complex cases well
6. **No Accessibility Audit**: While using semantic SwiftUI components, full accessibility testing not performed
7. **Landscape Layout**: UI optimized for portrait; landscape could be improved
8. **iPad Layout**: Could better utilize larger screen space

## 📖 Code Style & Conventions

- **Swift Style**: Follows Swift API Design Guidelines
- **Naming**: Clear, descriptive names; avoid abbreviations
- **Documentation**: Inline comments for complex logic, doc comments for public APIs
- **SwiftUI Idioms**: Leverages SwiftUI's declarative nature, avoids imperative code
- **Error Handling**: Uses Swift's typed errors and Result types where appropriate
- **State Management**: Single source of truth, unidirectional data flow

## 📄 License

This is a coding challenge project created for evaluation purposes.

## 👤 Author

Created as part of a technical assessment - January 2026
