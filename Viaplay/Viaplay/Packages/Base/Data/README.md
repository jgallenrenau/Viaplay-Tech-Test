# Data

## Overview
Implements domain repositories and orchestrates Remote + Local data sources with an offline-first policy.

## Responsibilities
- Implement `PageRepository` (from Domain)
- Fetch from HTTP (NetworkingKit) with conditional headers (If-None-Match)
- Use local cache (StorageKit) for JSON and ETag storage
- Map raw JSON into domain models (`Page`, `ContentSection`, `Section`)
- Provide data sources for feature modules (`SectionsDataSource`)
- Handle DTO to domain model transformation (`PageMapper`)

## Flow
```
UseCase → PageRepositoryImpl →
  ├─ Remote (HTTPClient.get)
  └─ Local  (JSONDiskCache + KeyValueStore)
```
- If server returns 304 Not Modified → return cached
- Else decode, save JSON + ETag, return fresh

## Public API
```swift
public final class PageRepositoryImpl: PageRepository {
  public init(http: HTTPClient, cache: JSONDiskCache, etagStore: KeyValueStore)
  public func getRootPage() async throws -> Page
  public func getPage(by url: URL) async throws -> Page
}

// Data Sources for Features
public final class SectionsDataSource: SectionsDataSourceProtocol {
  public init(pageRepository: PageRepository)
  public func fetchSections() async throws -> SectionsPage
}

// DTO Mapping
struct PageMapper {
  static func map(_ dto: PageDTO) -> Page
  static func mapToSectionsPage(_ dto: PageDTO) -> SectionsPage
}
```

## Directory layout
- `Sources/Data/PageRepositoryImpl.swift` - Main repository implementation
- `Sources/Data/DataSources/SectionsDataSource.swift` - Feature data source
- `Sources/Data/Mappers/PageMapper.swift` - DTO to domain mapping

## Testing
- Stub `HTTPClient` via `URLProtocol`
- Use in-memory/temp implementations for cache and key-value store
