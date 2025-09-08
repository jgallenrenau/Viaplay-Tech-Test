# Sections ✨

## 👀 Overview
**Feature module** for the home/sections list following _Clean Architecture_ (Domain/Data/View) with **MVVM + UseCase**. It implements the sections list experience with DI via `SectionsFactory`.

## Responsibilities
- **UI Presentation**: SwiftUI views for sections list display (iOS and tvOS)
- **State Management**: ViewModel for managing UI state and user interactions
- **Business Logic**: Integration with domain use cases for data retrieval
- **Navigation**: Handle navigation to section details
- **Description Caching**: Intelligent caching of section descriptions from API endpoints
- **Cross-Platform Support**: Platform-specific UI optimizations for iOS and tvOS

## Architecture
```
📦 Sections Feature
├── Sources/SectionsFeature
│   ├── Data/
│   │   ├── DataSource/
│   │   │   ├── SectionsDataSource.swift
│   │   │   └── SectionsDataSourceProtocol.swift
│   │   └── Repository/
│   │       └── SectionsRepository.swift  ← implementation
│   ├── View/
│   │   ├── ViewModel/SectionsViewModel.swift
│   │   ├── SectionsListView.swift        ← iOS view
│   │   └── SectionsListViewtvOS.swift    ← tvOS view
│   └── SectionsFactory.swift  ← dependency injection entry point
└── Tests
    ├── Unit/          ✅ ViewModel, UseCase, Repository, DataSource (+ Mocks)
    ├── Integration/   🔗 Repository ↔ DataSource
    └── Snapshot/      🖼️ SnapshotTesting for views (iOS + tvOS)
```

## 🧩 Dependencies
- **Domain**: domain entities (`Section`, `SectionsPage`) + `FetchSectionsUseCase` + `SectionDescriptionCacheService`
- **Data**: repository implementations for data access
- **DSKit**: UI components (`SectionRowView`, `LoadingView`, `ErrorView`)
- **NetworkingKit / StorageKit**: used by `PageRepositoryImpl` (via `SectionsFactory`)
- **SnapshotTesting** (tests only)

## Key Components

### SectionsListView (iOS)
iOS-optimized SwiftUI view that displays the list of content sections:
```swift
struct SectionsListView: View {
    @StateObject private var viewModel: SectionsViewModel
    
    var body: some View {
        // List of sections with loading states
        // Error handling and retry mechanisms
        // Navigation to section details
        // Touch-optimized interactions
        // Root page description in header
    }
}
```

### SectionsListViewtvOS (tvOS)
tvOS-optimized SwiftUI view with focus-based navigation:
```swift
struct SectionsListViewtvOS: View {
    @StateObject private var viewModel: SectionsViewModel
    
    var body: some View {
        // TV-optimized layout
        // Focus-based navigation
        // Remote control interactions
        // Larger fonts and touch targets
        // Root page description in header
    }
}
```

### 🧠 SectionsViewModel
Manages UI state and coordinates with domain `FetchSectionsUseCase` and description caching:
```swift
@MainActor
final class SectionsViewModel: ObservableObject {
    @Published var sections: [Section] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var rootPageDescription: String?
    
    private let fetchSectionsUseCase: FetchSectionsUseCaseProtocol
    private let cacheService: SectionDescriptionCacheService
    
    // Fetches real descriptions from section hrefs
    private func fetchSectionDescription(from href: URL) async throws -> String?
}
```

## 🔄 Data Flow
1) **View Load**: `SectionsListView` appears → `ViewModel.loadSections()`
2) **Use Case Call**: ViewModel → `FetchSectionsUseCase`
3) **Data Retrieval**: UseCase → `SectionsRepository` → `SectionsDataSource` → API/Cache
4) **Root Description**: Cache root page description from API response
5) **Section Descriptions**: Fetch real descriptions from each section's href
6) **Cache Storage**: Store all descriptions in `SectionDescriptionCacheService`
7) **State Update**: ViewModel updates `@Published` properties
8) **UI Refresh**: SwiftUI updates the view automatically

## Testing
- **ViewModel Tests**: Test state management and use case integration
- **View Tests**: Test UI rendering and user interactions
- **Mock Use Cases**: Use fake implementations for isolated testing

## 🗂️ Directory Layout (summary)
- `Sources/SectionsFeature/View/` - SwiftUI views + ViewModel (iOS + tvOS)
- `Sources/SectionsFeature/Data/` - DataSource + Repository
- `Sources/SectionsFeature/SectionsFactory.swift` - DI entry point
- `Tests/Unit|Integration|Snapshot` - test targets (iOS + tvOS)

## 🚀 Example Wiring (App)
```swift
// Simplified with factory
SectionsListView(viewModel: SectionsFactory.makeSectionsViewModel())
```

## 🧪 Testing
- **Unit**: `Tests/Unit` (ViewModel, UseCase, Repository, DataSource)
- **Integration**: `Tests/Integration` (Repository with DataSource stub)
- **Snapshot**: `Tests/Snapshot` using [`SnapshotTesting`](https://github.com/pointfreeco/swift-snapshot-testing)

Tip: enable code coverage in Xcode (Scheme → Test → Options → ✅ Gather coverage)

