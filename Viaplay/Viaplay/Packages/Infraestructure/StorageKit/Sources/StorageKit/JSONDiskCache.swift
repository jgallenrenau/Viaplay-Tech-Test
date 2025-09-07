import Foundation

public protocol JSONDiskCache {
    func read<T: Decodable>(for key: String, as type: T.Type) throws -> T?
    func write<T: Encodable>(_ value: T, for key: String) throws
    func delete(for key: String) throws
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
        print("💾 [StorageKit] Attempting to read cache for key: \(key)")
        
        guard FileManager.default.fileExists(atPath: url.path) else { 
            print("📭 [StorageKit] Cache file not found for key: \(key)")
            return nil 
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("📖 [StorageKit] Cache file found, size: \(data.count) bytes")
            let result = try decoder.decode(T.self, from: data)
            print("✅ [StorageKit] Successfully decoded cached data for key: \(key)")
            return result
        } catch {
            print("❌ [StorageKit] Failed to decode cached data for key: \(key) - \(error.localizedDescription)")
            throw error
        }
    }

    public func write<T: Encodable>(_ value: T, for key: String) throws {
        let url = directory.appendingPathComponent(key)
        print("💾 [StorageKit] Attempting to write cache for key: \(key)")
        
        do {
            let data = try encoder.encode(value)
            print("📝 [StorageKit] Encoded data, size: \(data.count) bytes")
            try data.write(to: url, options: .atomic)
            print("✅ [StorageKit] Successfully cached data for key: \(key)")
        } catch {
            print("❌ [StorageKit] Failed to cache data for key: \(key) - \(error.localizedDescription)")
            throw error
        }
    }
    
    public func delete(for key: String) throws {
        let url = directory.appendingPathComponent(key)
        print("🗑️ [StorageKit] Attempting to delete cache for key: \(key)")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("📭 [StorageKit] Cache file not found for deletion, key: \(key)")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
            print("✅ [StorageKit] Successfully deleted cache for key: \(key)")
        } catch {
            print("❌ [StorageKit] Failed to delete cache for key: \(key) - \(error.localizedDescription)")
            throw error
        }
    }
}

public protocol KeyValueStore {
    func get(_ key: String) -> String?
    func set(_ value: String, for key: String)
}

public final class UserDefaultsStore: KeyValueStore {
    private let defaults: UserDefaults
    public init(defaults: UserDefaults = .standard) { self.defaults = defaults }
    
    public func get(_ key: String) -> String? { 
        let value = defaults.string(forKey: key)
        if let value = value {
            print("🔑 [KeyValueStore] Retrieved value for key '\(key)': \(value)")
        } else {
            print("🔍 [KeyValueStore] No value found for key: \(key)")
        }
        return value
    }
    
    public func set(_ value: String, for key: String) { 
        print("🔑 [KeyValueStore] Setting value for key '\(key)': \(value)")
        defaults.set(value, forKey: key)
        print("✅ [KeyValueStore] Value stored successfully")
    }
}
