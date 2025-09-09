import XCTest
@testable import NetworkingKit

final class URLSessionHTTPClientTests: XCTestCase {

    private class URLProtocolStub: URLProtocol {
        static var stubResponse: (data: Data, response: HTTPURLResponse, error: Error?)?

        override class func canInit(with request: URLRequest) -> Bool { true }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
        override func startLoading() {
            guard let client = client, let stub = URLProtocolStub.stubResponse else { return }
            if let error = stub.error {
                client.urlProtocol(self, didFailWithError: error)
            } else {
                client.urlProtocol(self, didReceive: stub.response, cacheStoragePolicy: .notAllowed)
                client.urlProtocol(self, didLoad: stub.data)
                client.urlProtocolDidFinishLoading(self)
            }
        }
        override func stopLoading() {}
    }

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: config)
    }

    func test_get_deliversResponseOn200() async throws {
        let url = URL(string: "https://example.com/test")!
        let data = Data("{\"ok\":true}".utf8)
        let headers = ["Etag": "abc123", "Content-Type": "application/json"]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)!
        URLProtocolStub.stubResponse = (data, response, nil)

        let sut = URLSessionHTTPClient(session: makeSession())
        let result = try await sut.get(url, headers: ["X-Test": "1"]) // also test header forwarding compiles

        XCTAssertEqual(result.statusCode, 200)
        XCTAssertEqual(result.headers["Etag"], "abc123")
        XCTAssertEqual(result.data, data)
    }

    func test_get_throwsOnTransportError() async {
        let url = URL(string: "https://example.com/error")!
        URLProtocolStub.stubResponse = (Data(), HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: [:])!, URLError(.notConnectedToInternet))

        let sut = URLSessionHTTPClient(session: makeSession())

        do {
            _ = try await sut.get(url, headers: [:])
            XCTFail("Expected to throw, got value")
        } catch { /* expected */ }
    }

    func test_get_throwsOnNonHTTPResponse() async {
        class NonHTTPProtocol: URLProtocol {
            override class func canInit(with request: URLRequest) -> Bool { true }
            override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
            override func startLoading() {
                let response = URLResponse(url: request.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocolDidFinishLoading(self)
            }
            override func stopLoading() {}
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [NonHTTPProtocol.self]
        let session = URLSession(configuration: config)

        let sut = URLSessionHTTPClient(session: session)
        do {
            _ = try await sut.get(URL(string: "https://example.com/nonhttp")!, headers: [:])
            XCTFail("Expected to throw on non HTTP response")
        } catch { /* expected */ }
    }
}


