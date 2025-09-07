# Sections ✨

## 👀 Overview
**Feature module** for the home/sections list following _Clean Architecture_ (Domain/Data/View) with **MVVM + UseCase**. It implements the sections list experience with DI via `SectionsFactory`.

## Responsibilities
- **UI Presentation**: SwiftUI views for sections list display
- **State Management**: ViewModel for managing UI state and user interactions
- **Business Logic**: Integration with domain use cases for data retrieval
- **Navigation**: Handle navigation to section details

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
│   │   ├── Components/SectionRowView.swift
│   │   ├── ViewModel/SectionsViewModel.swift
│   │   └── SectionsListView.swift
│   ├── Resources/Localizable.strings
│   └── SectionsFactory.swift  ← dependency injection entry point
└── Tests
    ├── Unit/          ✅ ViewModel, UseCase, Repository, DataSource (+ Mocks)
    ├── Integration/   🔗 Repository ↔ DataSource
    └── Snapshot/      🖼️ SnapshotTesting for views
```

## 🧩 Dependencies
- **Domain**: domain entities (`Section`, `SectionsPage`) + `FetchSectionsUseCase`
- **Data**: repository implementations for data access
- **NetworkingKit / StorageKit**: used by `PageRepositoryImpl` (via `SectionsFactory`)
- **SnapshotTesting** (tests only)

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

### 🧠 SectionsViewModel
Manages UI state and coordinates with domain `FetchSectionsUseCase`:
```swift
@MainActor
final class SectionsViewModel: ObservableObject {
    @Published var sections: [Section] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let fetchSectionsUseCase: FetchSectionsUseCaseProtocol
}
```

## 🔄 Data Flow
1) **View Load**: `SectionsListView` appears → `ViewModel.loadSections()`
2) **Use Case Call**: ViewModel → `FetchSectionsUseCase`
3) **Data Retrieval**: UseCase → `SectionsRepository` → `SectionsDataSource` → API/Cache
4) **State Update**: ViewModel updates `@Published` properties
5) **UI Refresh**: SwiftUI updates the view automatically

## Testing
- **ViewModel Tests**: Test state management and use case integration
- **View Tests**: Test UI rendering and user interactions
- **Mock Use Cases**: Use fake implementations for isolated testing

## 🗂️ Directory Layout (summary)
- `Sources/SectionsFeature/View/` - SwiftUI views + ViewModel
- `Sources/SectionsFeature/Data/` - DataSource + Repository
- `Sources/SectionsFeature/Resources/` - Strings/assets
- `Sources/SectionsFeature/SectionsFactory.swift` - DI entry point
- `Tests/Unit|Integration|Snapshot` - test targets

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

