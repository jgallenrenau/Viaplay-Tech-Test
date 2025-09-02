# NetworkingKit

## Overview
Infrastructure package for HTTP concerns and endpoint helpers.

## Responsibilities
- Define `HTTPClient` protocol and `URLSessionHTTPClient` implementation
- Normalize responses into `HTTPResponse` (status, headers, data)
- Provide `ViaplayAPI` URL builders (e.g. `rootURL()`)

## Public API
```swift
public protocol HTTPClient {
  func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse
}

public struct HTTPResponse { public let statusCode: Int; public let headers: [String:String]; public let data: Data }

public enum ViaplayAPI { public static func rootURL() -> URL }
```

## Usage example
```swift
let client: HTTPClient = URLSessionHTTPClient()
let response = try await client.get(ViaplayAPI.rootURL(), headers: [:])
```

## Dependencies
Foundation only. No domain coupling.

## Testing
Use `URLProtocol` to stub requests and validate headers (e.g., `If-None-Match`) and status 304 logic.
