# DomainKit

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
- `Sources/DomainKit/DomainModels.swift`
- `Sources/DomainKit/Contracts.swift`
- `Sources/DomainKit/UseCases.swift`

## Dependencies
None (Foundation only). This keeps the domain portable and easy to test.

## Error handling
Use `DomainError` to represent cross-layer failures and map infra errors in DataKit to these types.

## Testing
- Unit-test use cases by injecting a fake `PageRepository`.
- Snapshot/infra tests belong to other modules, not here.
