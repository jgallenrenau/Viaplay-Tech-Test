<p align="center">
  <img src="../../../../DocResources/viaplay_image_header.jpeg" alt="Viaplay Header" width="600"/>
</p>

# 🎯 DetailSection Feature Module

## ✨ Overview
**Feature module** for the detail/section content following _Clean Architecture_ (Domain/Data/View) with **MVVM + UseCase**. It implements the detail view experience with DI via `DetailFactory`.

## 🏗️ Architecture
```
DetailSection Feature
├── Data/
│   ├── DataSource/
│   │   ├── DetailDataSourceProtocol.swift     # Protocol for data fetching
│   │   └── DetailDataSource.swift             # Fetches detail data from PageRepository
│   └── Repository/
│       └── DetailRepositoryImpl.swift         # Implements Domain.DetailRepositoryProtocol
├── View/
│   ├── Components/
│   │   └── DetailItemView.swift               # Reusable UI for a single detail item
│   ├── ViewModel/
│   │   └── DetailViewModel.swift              # Manages UI state and interacts with UseCase
│   └── DetailView.swift                       # Main detail view UI
├── Resources/
│   └── Localizable.strings                    # Localized strings
├── DetailFactory.swift                        # Dependency injection factory
└── Tests/
    ├── Unit/                                  # Isolated tests for business logic
    │   ├── Mocks.swift                        # Test doubles (spies, stubs)
    │   ├── DetailViewModelTests.swift
    │   ├── FetchDetailUseCaseTests.swift
    │   ├── DetailRepositoryImplTests.swift
    │   └── DetailDataSourceTests.swift
    ├── Integration/                           # Tests across multiple layers
    │   └── DetailIntegrationTests.swift
    └── Snapshot/                              # UI snapshot tests
        └── DetailViewSnapshotTests.swift
```

## 🔗 Dependencies
- **`Domain`**: Core business logic, models (`DetailItem`, `DetailPage`), and use cases (`FetchDetailUseCase`).
- **`Data`**: Base data layer abstractions (e.g., `PageRepository`).
- **`NetworkingKit`**: Handles network requests.
- **`StorageKit`**: Manages data caching and persistence.
- **`DSKit`**: Reusable UI components for consistent design.
- **`SnapshotTesting`**: For visual regression testing of SwiftUI views.

## 🔄 Data Flow
1. **View Load**: `DetailView` appears → `DetailViewModel.loadDetail()`
2. **Use Case Call**: `ViewModel` calls `Domain.FetchDetailUseCase.execute(section:)`
3. **Repository Call**: `UseCase` calls `Domain.DetailRepositoryProtocol.fetchDetail(for:)` (implemented by `DetailRepositoryImpl`)
4. **Data Source Call**: `Repository` calls `DetailDataSourceProtocol.fetchDetail(for:)`
5. **Data Retrieval**: `DataSource` uses `PageRepository` (from `Data` layer) to fetch raw data.
6. **Mapping**: `DataSource` maps `ContentSection` to `Domain.DetailPage` and `Domain.DetailItem`.
7. **State Update**: `ViewModel` updates `@Published` properties with `Domain.DetailPage` data.
8. **UI Refresh**: SwiftUI automatically updates the view.

## 🧪 Testing
The `DetailSection` package includes a comprehensive testing suite:

- **Unit Tests** (`Tests/Unit`):
    - Isolated tests for `DetailViewModel`, `FetchDetailUseCase`, `DetailRepositoryImpl`, and `DetailDataSource`.
    - Uses mocks and stubs (`Mocks.swift`) for dependency isolation.
    - Employs `setUp()` and `tearDown()` for consistent test environment setup.
- **Integration Tests** (`Tests/Integration`):
    - Tests the interaction between `DataSource`, `Repository`, and `UseCase` layers.
- **Snapshot Tests** (`Tests/Snapshot`):
    - Leverages [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) to capture and compare UI snapshots of `DetailView`.
    - Ensures visual consistency across changes.

## 🛠️ Example Wiring (App)
```swift
import DetailSection
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Your sections list
                ForEach(sections) { section in
                    NavigationLink(destination: DetailView(section: section)) {
                        Text(section.title)
                    }
                }
            }
        }
    }
}

// Or with custom ViewModel
struct CustomDetailView: View {
    let section: ContentSection
    
    var body: some View {
        DetailView(
            section: section,
            viewModel: DetailFactory.makeDetailViewModel(for: section)
        )
    }
}
```

## 📱 Features
- **Clean Architecture**: Separation of concerns with Domain/Data/View layers
- **MVVM Pattern**: Reactive UI updates with `@Published` properties
- **Dependency Injection**: Easy testing and modularity via `DetailFactory`
- **Comprehensive Testing**: Unit, Integration, and Snapshot tests
- **Localization Ready**: Support for multiple languages via `Localizable.strings`
- **SwiftUI Native**: Modern, declarative UI framework
- **Cross-Platform**: iOS 16+ and macOS 12+ support