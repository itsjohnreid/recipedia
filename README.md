# 📘 Recipedia

A native iOS recipe browsing app built with Swift and SwiftUI that allows users to search and filter cooking recipes.

## 🎯 Features

- Browse a collection of cooking recipes
- Search recipes by title and description
- Filter by dietary attributes (vegetarian, vegan, gluten-free, etc.)
- Filter by number of servings
- Include/exclude specific ingredients
- Clean, intuitive SwiftUI interface
- Recipe detail view with full ingredients and instructions

## 🛠️ Technical Stack

- **Swift** with **SwiftUI**
- **@Observable** macro for state management (iOS 17+)
- **async/await** for data loading
- **Codable** for JSON parsing
- Local JSON file as mock API response

## 📦 Setup Instructions

1. Open `Recipedia.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)

**Requirements:**
- Xcode 15+
- iOS 17.0+ deployment target

## 🏗️ Architecture

### MVVM Pattern

- **Model**: `Recipe` - Data model with Codable conformance
- **View**: SwiftUI views for list, detail, and filtering
- **ViewModel**: `RecipeListViewModel` - Manages search/filter state and recipe filtering logic
- **Service**: `RecipeService` - Handles recipe data loading from JSON

### Key Components

- `Recipe.swift` - Recipe model with dietary attributes
- `RecipeService.swift` - Loads recipes from bundled JSON file
- `RecipeListViewModel.swift` - Contains all filter logic and computed filtered recipes
- `RecipeListView.swift` - Main list view with search and filter UI
- `RecipeDetailView.swift` - Detail view showing full recipe information
- `FilterSheetView.swift` - Modal sheet for applying filters
- `recipes.json` - 15 sample recipes with varied dietary attributes

### Filtering Logic

The app supports multiple filter types that work together:
1. **Text Search** - Searches recipe titles and descriptions
2. **Dietary Attributes** - Multi-select filtering for vegetarian, vegan, gluten-free, etc.
3. **Servings** - Range-based filtering (1-2, 3-4, 5-6, 7+)
4. **Include Ingredients** - Comma-separated list of required ingredients
5. **Exclude Ingredients** - Comma-separated list of ingredients to avoid

All filters are applied using AND logic - recipes must match all active filters.

## 🎨 Design Decisions

### 1. @Observable Macro
Using the modern `@Observable` macro instead of `ObservableObject` provides cleaner syntax and more efficient view updates without boilerplate.

### 2. Service Layer
The `RecipeService` abstracts data loading, making it easy to swap the local JSON file for a real API endpoint in the future.

### 3. Multi-Select Dietary Filtering
Rather than a single "vegetarian only" toggle, the app supports filtering by any combination of dietary attributes, providing more flexibility for users with specific dietary needs.

### 4. Component-Based UI
Views are broken into small, reusable components (`RecipeCardView`, `DietaryTagView`) following SwiftUI best practices.

### 5. Native SwiftUI Components
Using built-in components like `ContentUnavailableView`, `List`, and `.searchable()` for a native iOS feel.

## 🤔 Assumptions & Tradeoffs

### Assumptions
- Recipes are stored locally in a JSON file (mimicking an API response structure)
- All recipes have required fields (id, title, description, servings, ingredients, instructions)
- Dietary attributes are predefined enum cases
- Users expect AND logic when multiple filters are applied

### Tradeoffs
- **No Persistence**: Filter selections don't persist between app launches (could be added with UserDefaults or SwiftData)
- **No Images**: Recipes don't include images to keep the sample data simple
- **Simple Error Handling**: Basic error logging instead of comprehensive error states
- **No Sorting**: Recipes display in JSON order (could add sort by title, servings, etc.)
- **No Recipe Editing**: Read-only interface (appropriate for a browsing app)

## 📝 Known Limitations

- Requires iOS 17+ for `@Observable` macro
- Ingredient filtering is case-insensitive substring matching (not smart parsing)
- No offline caching or data persistence
- Filter badge shows count but doesn't indicate which specific filters are active
- Search doesn't highlight matching terms in results

## 🧪 Testing

The project includes SwiftUI Previews for rapid development and visual testing. To test:

1. **Preview in Xcode**: Use the preview canvas for individual views
2. **Search**: Type "chicken" or "pizza" in the search bar
3. **Dietary Filters**: Toggle multiple dietary attributes like "Vegetarian" and "Gluten Free"
4. **Servings**: Select different serving ranges
5. **Ingredients**: Try including "garlic, tomatoes" and excluding "meat"
6. **Navigation**: Tap recipe cards to view full details

---

Built as a coding challenge to demonstrate Swift, SwiftUI, and iOS development skills.
