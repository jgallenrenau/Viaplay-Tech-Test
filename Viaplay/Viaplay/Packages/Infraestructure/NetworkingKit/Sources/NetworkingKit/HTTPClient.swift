import Foundation

public struct HTTPResponse: Sendable {
    public let statusCode: Int
    public let headers: [String: String]
    public let data: Data
}

public protocol HTTPClient {
    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    public init(session: URLSession = .shared) { self.session = session }
    public func get(_ url: URL, headers: [String: String] = [:]) async throws -> HTTPResponse {
        var request = URLRequest(url: url)
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        let headerFields = http.allHeaderFields.reduce(into: [String: String]()) { acc, pair in
            if let key = pair.key as? String, let value = pair.value as? String { acc[key] = value }
        }
        return HTTPResponse(statusCode: http.statusCode, headers: headerFields, data: data)
    }
}

public enum ViaplayAPI {
    public static func rootURL() -> URL { URL(string: "https://content.viaplay.com/ios-se")! }
}
