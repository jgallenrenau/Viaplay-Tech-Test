# DetailSection

## Overview
Feature module for the detail screen following MVVM + UseCase pattern. This module implements the detailed view for individual content sections with comprehensive information display.

## Responsibilities
- **UI Presentation**: SwiftUI views for section detail display
- **State Management**: ViewModel for managing UI state and user interactions
- **Business Logic**: Integration with domain use cases for data retrieval
- **Content Display**: Show detailed section information and metadata

## Architecture
```
DetailSection Feature
├── Views/
│   └── DetailView.swift            # Main detail view UI
└── Tests/
    └── DetailViewTests.swift       # Feature tests
```

## Dependencies
- **Domain**: Uses domain models and use cases
- **DSKit**: Reusable UI components for consistent design
- **Data**: Repository implementations for data access

## Key Components

### DetailView
SwiftUI view that displays detailed section information:
```swift
struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    
    var body: some View {
        // Section details with rich content
        // Loading states and error handling
        // Navigation and user interactions
    }
}
```

## Data Flow
1. **View Load**: DetailView appears with section data
2. **Use Case Call**: ViewModel calls appropriate use case
3. **Data Retrieval**: Use case → Repository → API/Cache
4. **State Update**: ViewModel updates @Published properties
5. **UI Refresh**: SwiftUI automatically updates the view

## Testing
- **View Tests**: Test UI rendering and user interactions
- **Mock Use Cases**: Use fake implementations for isolated testing
- **State Tests**: Verify proper state management

## Directory Layout
- `Sources/DetailSection/DetailView.swift` - Main UI view
- `Tests/DetailSectionTests/DetailViewTests.swift` - Feature tests

## Example Wiring (App)
```swift
let repo = PageRepositoryImpl(http: http, cache: cache, etagStore: etags)
let useCase = GetPage(repository: repo)
// later: DetailViewModel(useCase: useCase)
```
