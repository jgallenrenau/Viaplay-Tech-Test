# DataKit

## Overview
Implements domain repositories and orchestrates Remote + Local data sources with an offline-first policy.

## Responsibilities
- Implement `PageRepository` (from DomainKit)
- Fetch from HTTP (NetworkingKit) with conditional headers (If-None-Match)
- Use local cache (StorageKit) for JSON and ETag storage
- Map raw JSON into domain models (`Page`, `Section`)

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
```

## Directory layout
- `Sources/DataKit/PageRepositoryImpl.swift`

## Testing
- Stub `HTTPClient` via `URLProtocol`
- Use in-memory/temp implementations for cache and key-value store
