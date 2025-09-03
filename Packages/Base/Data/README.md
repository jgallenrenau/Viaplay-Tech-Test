# Data

## Overview
Data layer that implements domain contracts by orchestrating data sources. This module bridges the gap between the pure domain logic and external data sources (API, cache, storage).

## Responsibilities
- **Repository Implementation**: Concrete implementations of domain repository contracts
- **Data Mapping**: Transform DTOs from external sources to domain models
- **Data Coordination**: Orchestrate between remote (API) and local (cache) data sources
- **Caching Strategy**: Implement ETag-based caching and offline-first policies
- **Error Handling**: Map infrastructure errors to domain errors

## Architecture
```
Data Layer
├── Repositories/
│   └── PageRepositoryImpl.swift    # Implements PageRepository contract
├── Mappers/
│   └── PageMapper.swift            # DTO ↔ Domain model mapping
└── DTOs/
    └── PageDTO.swift               # Network response models
```

## Dependencies
- **Domain**: Implements domain contracts and uses domain models
- **NetworkingKit**: Makes HTTP requests to external APIs
- **StorageKit**: Manages local caching and persistence

## Key Components

### PageRepositoryImpl
Implements the `PageRepository` contract from Domain:
```swift
public final class PageRepositoryImpl: PageRepository {
    private let httpClient: HTTPClient
    private let cache: JSONDiskCache
    private let keyValueStore: KeyValueStore
    
    public func getPage(url: URL) async throws -> Page {
        // 1. Check cache for ETag
        // 2. Make conditional request with If-None-Match
        // 3. Handle 200 OK vs 304 Not Modified
        // 4. Map DTO to domain model
        // 5. Update cache if needed
    }
}
```

### Data Flow
1. **Request**: ViewModel calls UseCase → Repository
2. **Cache Check**: Repository checks for existing ETag in StorageKit
3. **Network Request**: Makes conditional GET with `If-None-Match` header
4. **Response Handling**:
   - **200 OK**: New data → Map DTO → Update cache → Return domain model
   - **304 Not Modified**: Use cached data → Return domain model
   - **Network Error**: Fallback to cache if available
5. **Return**: Domain model back to UseCase → ViewModel → View

## Caching Strategy
- **ETag-based**: Uses `If-None-Match` headers for efficient caching
- **Offline-first**: Always attempts to serve cached data when possible
- **TTL Support**: Optional time-based expiration for cache entries
- **Storage**: JSONDiskCache for content, KeyValueStore for metadata (ETags)

## Error Handling
Maps infrastructure errors to domain errors:
- **Network errors** → `DomainError.networkUnavailable`
- **Parsing errors** → `DomainError.invalidData`
- **Cache errors** → `DomainError.storageUnavailable`

## Testing
- **Strategy**: Repository tests with stubbed HTTPClient and temporary storage
- **Scenarios**: 200 OK, 304 Not Modified, network errors, cache fallbacks
- **Tools**: XCTest with mock objects and temporary file system

## Directory Layout
- `Sources/Data/PageRepositoryImpl.swift` - Main repository implementation
- `Sources/Data/Mappers/PageMapper.swift` - DTO to domain mapping
- `Sources/Data/DTOs/PageDTO.swift` - Network response models
- `Tests/DataTests/PageRepositoryImplTests.swift` - Repository tests

## Dependencies
- Domain (contracts and models)
- NetworkingKit (HTTP client)
- StorageKit (caching and persistence)

## Error Handling
Use `DomainError` to represent cross-layer failures and map infrastructure errors to these types.
