# StorageKit

## Overview
Local persistence utilities for caching and storage operations. Provides clean abstractions for JSON caching and key-value storage with no domain logic coupling.

## Responsibilities
- **JSON Caching**: Protocol-based JSON disk cache for codable objects
- **Key-Value Storage**: Simple key-value store for metadata (ETags, timestamps)
- **File Management**: File-based storage implementation using app caches directory
- **Storage Abstraction**: Protocol-based design for easy testing and swapping implementations

## Architecture
```
StorageKit
├── JSONDiskCache.swift            # JSON caching protocol and implementation
├── KeyValueStore.swift            # Key-value storage protocol and implementation
└── Tests/
    └── StorageTests.swift         # Storage layer tests
```

## Dependencies
Foundation only. No domain coupling to keep storage concerns isolated.

## Key Components

### JSONDiskCache Protocol
Clean abstraction for JSON object persistence:
```swift
public protocol JSONDiskCache {
    func read<T: Decodable>(for key: String, as: T.Type) throws -> T?
    func write<T: Encodable>(_ value: T, for key: String) throws
}
```

### KeyValueStore Protocol
Simple key-value storage for metadata:
```swift
public protocol KeyValueStore {
    func get(_ key: String) -> String?
    func set(_ value: String, for key: String)
}
```

### FileJSONDiskCache
File-based implementation storing JSON files in app caches directory:
- **Location**: `~/Library/Caches/` directory
- **Format**: JSON files with configurable keys
- **Error Handling**: Throws errors for file system issues

### UserDefaultsStore
UserDefaults-based implementation for key-value storage:
- **Use Case**: ETags, Last-Modified headers, app preferences
- **Persistence**: Survives app restarts
- **Performance**: Fast access for small values

## Usage Examples

### JSON Caching
```swift
let cache = FileJSONDiskCache()
try cache.write(page, for: "root.json")
let restored: Page? = try cache.read(for: "root.json", as: Page.self)
```

### Key-Value Storage
```swift
let store = UserDefaultsStore()
store.set("etag-value", for: "root-etag")
let etag = store.get("root-etag")
```

## Caching Strategy
- **ETag Storage**: Store server ETags for conditional requests
- **Content Caching**: Cache JSON responses for offline access
- **TTL Support**: Optional time-based expiration (planned)
- **Cleanup**: Automatic cleanup of expired cache entries

## Testing
- **Temporary Directories**: Point `FileJSONDiskCache` to temporary directories
- **Cleanup**: Clean up test files in `tearDown()`
- **Roundtrip Tests**: Test JSON serialization/deserialization
- **Error Scenarios**: Test file system errors and permissions

## Directory Layout
- `Sources/StorageKit/JSONDiskCache.swift` - JSON caching implementation
- `Sources/StorageKit/KeyValueStore.swift` - Key-value storage implementation
- `Tests/StorageKitTests/StorageTests.swift` - Storage tests
