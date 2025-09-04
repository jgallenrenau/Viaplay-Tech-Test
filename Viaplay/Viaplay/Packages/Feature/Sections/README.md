# Sections

## Overview
Feature module for the home/sections list following MVVM + UseCase pattern. This module implements the main content browsing experience with sections list and navigation.

## Responsibilities
- **UI Presentation**: SwiftUI views for sections list display
- **State Management**: ViewModel for managing UI state and user interactions
- **Business Logic**: Integration with domain use cases for data retrieval
- **Navigation**: Handle navigation to section details

## Architecture
```
Sections Feature
├── Views/
│   └── SectionsListView.swift      # Main sections list UI
├── ViewModels/
│   └── SectionsViewModel.swift     # State management and business logic
└── Tests/
    └── SectionsListViewTests.swift # Feature tests
```

## Dependencies
- **Domain**: Uses domain models and use cases
- **DSKit**: Reusable UI components for consistent design
- **Data**: Repository implementations for data access

## Key Components

### SectionsListView
SwiftUI view that displays the list of content sections:
```swift
struct SectionsListView: View {
    @StateObject private var viewModel: SectionsViewModel
    
    var body: some View {
        // List of sections with loading states
        // Error handling and retry mechanisms
        // Navigation to section details
    }
}
```

### SectionsViewModel
Manages UI state and coordinates with domain use cases:
```swift
@MainActor
final class SectionsViewModel: ObservableObject {
    @Published var sections: [ContentSection] = []
    @Published var isLoading = false
    @Published var error: DomainError?
    
    private let getRootPage: GetRootPageUseCase
    
    func loadSections() async {
        // Call use case, handle loading states
        // Update UI state based on results
    }
}
```

## Data Flow
1. **View Load**: SectionsListView appears → ViewModel.loadSections()
2. **Use Case Call**: ViewModel calls GetRootPageUseCase
3. **Data Retrieval**: Use case → Repository → API/Cache
4. **State Update**: ViewModel updates @Published properties
5. **UI Refresh**: SwiftUI automatically updates the view

## Testing
- **ViewModel Tests**: Test state management and use case integration
- **View Tests**: Test UI rendering and user interactions
- **Mock Use Cases**: Use fake implementations for isolated testing

## Directory Layout
- `Sources/Sections/SectionsListView.swift` - Main UI view
- `Sources/Sections/SectionsViewModel.swift` - State management
- `Tests/SectionsTests/SectionsListViewTests.swift` - Feature tests

## Example Wiring (App)
```swift
let http = URLSessionHTTPClient()
let cache = FileJSONDiskCache()
let etags = UserDefaultsStore()
let repo = PageRepositoryImpl(http: http, cache: cache, etagStore: etags)
let useCase = GetRootPage(repository: repo)
let vm = SectionsViewModel(getRootPage: useCase)
SectionsListView(viewModel: vm)
```
