# StorageKit

## Overview
Local persistence utilities (no domain logic). Similar separation can be seen in production apps (e.g., a dedicated cache layer).

## Responsibilities
- `JSONDiskCache` protocol for reading/writing codable payloads
- `FileJSONDiskCache` implementation storing files under Caches
- `KeyValueStore` protocol + `UserDefaultsStore` for ETag/Last-Modified

## Public API
```swift
public protocol JSONDiskCache {
  func read<T: Decodable>(for key: String, as: T.Type) throws -> T?
  func write<T: Encodable>(_ value: T, for key: String) throws
}

public protocol KeyValueStore { func get(_ key: String) -> String?; func set(_ value: String, for key: String) }
```

## Usage example
```swift
let cache = FileJSONDiskCache()
try cache.write(page, for: "root.json")
let restored: Page? = try cache.read(for: "root.json", as: Page.self)
```

## Testing
Point `FileJSONDiskCache` to a temporary directory and clean it up in `tearDown()`.
