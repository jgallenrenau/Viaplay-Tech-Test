import Foundation

public protocol JSONDiskCache {
    func read<T: Decodable>(for key: String, as type: T.Type) throws -> T?
    func write<T: Encodable>(_ value: T, for key: String) throws
}

public final class FileJSONDiskCache: JSONDiskCache {
    private let directory: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(directory: URL? = nil, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        if let directory { self.directory = directory } else {
            self.directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
        self.decoder = decoder
        self.encoder = encoder
    }

    public func read<T: Decodable>(for key: String, as type: T.Type) throws -> T? {
        let url = directory.appendingPathComponent(key)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }

    public func write<T: Encodable>(_ value: T, for key: String) throws {
        let url = directory.appendingPathComponent(key)
        let data = try encoder.encode(value)
        try data.write(to: url, options: .atomic)
    }
}

public protocol KeyValueStore {
    func get(_ key: String) -> String?
    func set(_ value: String, for key: String)
}

public final class UserDefaultsStore: KeyValueStore {
    private let defaults: UserDefaults
    public init(defaults: UserDefaults = .standard) { self.defaults = defaults }
    public func get(_ key: String) -> String? { defaults.string(forKey: key) }
    public func set(_ value: String, for key: String) { defaults.set(value, forKey: key) }
}
