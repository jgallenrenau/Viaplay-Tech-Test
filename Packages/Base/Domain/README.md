# Domain

## Overview
Owns pure domain models and contracts. No networking, no storage, no UI.

## Responsibilities
- Define domain entities: `Page`, `Section`
- Define domain errors: `DomainError`
- Own repository contract: `PageRepository`
- Provide use cases: `GetRootPageUseCase`, `GetPageUseCase` and their thin implementations (`GetRootPage`, `GetPage`)

## Public API
```swift
public struct Page { public let title: String; public let description: String?; public let sections: [Section] }
public struct Section { public let title: String; public let description: String?; public let href: URL? }

public protocol PageRepository {
  func getRootPage() async throws -> Page
  func getPage(by url: URL) async throws -> Page
}

public protocol GetRootPageUseCase { func execute() async throws -> Page }
public protocol GetPageUseCase { func execute(url: URL) async throws -> Page }
```

## Directory layout
- `Sources/Domain/DomainModels.swift` - Core domain entities
- `Sources/Domain/Contracts.swift` - Repository and service contracts
- `Sources/Domain/UseCases.swift` - Business logic use cases

## Dependencies
None (Foundation only). This keeps the domain portable and easy to test.

## Error handling
Use `DomainError` to represent cross-layer failures and map infra errors in Data to these types.

## Key Components

### Domain Models
- **Page**: Root content structure with sections
- **ContentSection**: Individual content sections with metadata
- **DomainError**: Standardized error types for the application

### Contracts (Protocols)
- **PageRepository**: Contract for data access operations
- **GetPageUseCase**: Contract for page retrieval business logic

### Use Cases
- **GetRootPageUseCase**: Retrieves the root page content
- **GetPageUseCase**: Retrieves specific page content by URL

## Testing
- Unit-test use cases by injecting a fake `PageRepository`
- Test domain models and business rules in isolation
- No external dependencies make testing fast and reliable
- Snapshot/infra tests belong to other modules, not here
