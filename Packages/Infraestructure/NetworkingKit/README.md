# NetworkingKit

## Overview
Infrastructure package for HTTP communication and network-related concerns. Provides a clean abstraction for making HTTP requests with support for conditional requests and caching headers.

## Responsibilities
- **HTTP Client**: Protocol-based HTTP client with URLSession implementation
- **Response Handling**: Normalized HTTP response structure with status, headers, and data
- **API Endpoints**: URL builders for Viaplay API endpoints
- **Header Management**: Support for conditional requests (ETag, If-None-Match)

## Architecture
```
NetworkingKit
├── HTTPClient.swift              # Protocol and URLSession implementation
├── HTTPResponse.swift            # Response structure
├── ViaplayAPI.swift              # API endpoint builders
└── Tests/
    └── HTTPClientTests.swift     # Network layer tests
```

## Dependencies
Foundation only. No domain coupling to keep networking concerns isolated.

## Key Components

### HTTPClient Protocol
Clean abstraction for HTTP operations:
```swift
public protocol HTTPClient {
    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse
}
```

### HTTPResponse
Normalized response structure:
```swift
public struct HTTPResponse {
    public let statusCode: Int
    public let headers: [String: String]
    public let data: Data
}
```

### ViaplayAPI
Endpoint builders for API URLs:
```swift
public enum ViaplayAPI {
    public static func rootURL() -> URL
    // Additional endpoint builders as needed
}
```

## Usage Example
```swift
let client: HTTPClient = URLSessionHTTPClient()
let response = try await client.get(ViaplayAPI.rootURL(), headers: [
    "If-None-Match": "etag-value"
])
```

## Conditional Requests
Supports ETag-based conditional requests for efficient caching:
- **If-None-Match**: Check if content has changed
- **304 Not Modified**: Server indicates no changes
- **200 OK**: New content available

## Testing
- **URLProtocol Stubbing**: Mock HTTP responses for testing
- **Header Validation**: Test conditional request headers
- **Status Code Handling**: Verify 200 OK vs 304 Not Modified logic
- **Error Scenarios**: Network failures, timeouts, invalid responses

## Directory Layout
- `Sources/NetworkingKit/HTTPClient.swift` - Main HTTP client
- `Sources/NetworkingKit/HTTPResponse.swift` - Response structure
- `Sources/NetworkingKit/ViaplayAPI.swift` - API endpoints
- `Tests/NetworkingKitTests/HTTPClientTests.swift` - Network tests
