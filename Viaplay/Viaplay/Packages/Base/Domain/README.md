# Domain

## Overview
Owns pure domain models and contracts. No networking, no storage, no UI.

## Responsibilities
- Define domain entities: `Page`, `ContentSection`, `Section`, `SectionsPage`, `DetailPage`
- Define domain errors: `DomainError`
- Own repository contract: `PageRepository`
- Provide use cases: `GetRootPageUseCase`, `GetPageUseCase` and their thin implementations (`GetRootPage`, `GetPage`)
- Manage description caching: `SectionDescriptionCacheService` for intelligent content caching

## Public API
```swift
public struct Page { public let title: String; public let description: String?; public let sections: [ContentSection] }
public struct ContentSection { public let title: String; public let description: String?; public let href: URL? }
public struct Section { public let id: String; public let title: String; public let description: String?; public let href: URL?; public let imageURL: URL? }
public struct SectionsPage { public let title: String; public let description: String?; public let sections: [Section]; public let rootDescription: String? }
public struct DetailPage { public let title: String; public let description: String?; public let items: [DetailItem] }

public protocol PageRepository {
  func getRootPage() async throws -> Page
  func getPage(by url: URL) async throws -> Page
}

public protocol GetRootPageUseCase { func execute() async throws -> Page }
public protocol GetPageUseCase { func execute(url: URL) async throws -> Page }

// Description Caching
public class SectionDescriptionCacheService: ObservableObject {
  func cacheRootPage(title: String, description: String?)
  func cacheSections(_ sections: [Section])
  func getSectionDescription(for sectionId: String) -> SectionDescriptionCache?
  func getRootPageDescription() -> RootPageCache?
}
```

## Directory layout
- `Sources/Domain/DomainModels.swift` - Core domain entities
- `Sources/Domain/Contracts.swift` - Repository and service contracts
- `Sources/Domain/UseCases.swift` - Business logic use cases
- `Sources/Domain/SectionDescriptionCacheService.swift` - Description caching service

## Dependencies
None (Foundation only). This keeps the domain portable and easy to test.

## Error handling
Use `DomainError` to represent cross-layer failures and map infra errors in Data to these types.

## Key Components

### Domain Models
- **Page**: Root content structure with sections
- **ContentSection**: Individual content sections with metadata
- **Section**: Enhanced section model with ID and image support
- **SectionsPage**: Page model with root description for caching
- **DetailPage**: Detailed page content with items
- **SectionDescriptionCache**: Cached section descriptions
- **RootPageCache**: Cached root page information
- **DomainError**: Standardized error types for the application

### Contracts (Protocols)
- **PageRepository**: Contract for data access operations
- **GetPageUseCase**: Contract for page retrieval business logic

### Use Cases
- **GetRootPageUseCase**: Retrieves the root page content
- **GetPageUseCase**: Retrieves specific page content by URL

### Caching Services
- **SectionDescriptionCacheService**: Manages intelligent caching of section descriptions
  - Caches root page descriptions
  - Caches individual section descriptions from their hrefs
  - Provides offline access to cached descriptions
  - Uses UserDefaults for persistence

## Testing
- Unit-test use cases by injecting a fake `PageRepository`
- Test domain models and business rules in isolation
- No external dependencies make testing fast and reliable
- Snapshot/infra tests belong to other modules, not here
