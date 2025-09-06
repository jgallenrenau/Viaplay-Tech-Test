import Foundation

/// Actor for thread-safe storage operations
@globalActor
public actor StorageActor {
    public static let shared = StorageActor()
    
    private var pendingWrites: [String: Task<Void, Error>] = [:]
    private var writeQueue: [String: Data] = [:]
    private let maxQueueSize = 100
    
    private init() {}
    
    /// Thread-safe write operation with queuing
    public func write<T: Codable>(_ object: T, for key: String) async throws {
        let data = try JSONEncoder().encode(object)
        
        // Check if write is already pending
        if let existingTask = pendingWrites[key] {
            print("⏳ [StorageActor] Write already pending for key: \(key)")
            try await existingTask.value
            return
        }
        
        // Create write task
        let task = Task<Void, Error> {
            try await self.performWrite(data, for: key)
        }
        
        pendingWrites[key] = task
        defer {
            pendingWrites.removeValue(forKey: key)
        }
        
        do {
            try await task.value
            print("✅ [StorageActor] Write completed for key: \(key)")
        } catch {
            print("❌ [StorageActor] Write failed for key \(key): \(error)")
            throw error
        }
    }
    
    /// Thread-safe read operation
    public func read<T: Codable>(_ type: T.Type, for key: String) async throws -> T? {
        print("📖 [StorageActor] Reading data for key: \(key)")
        
        // Simulate storage read (in real implementation, this would read from disk)
        guard let data = writeQueue[key] else {
            print("📭 [StorageActor] No data found for key: \(key)")
            return nil
        }
        
        let object = try JSONDecoder().decode(type, from: data)
        print("✅ [StorageActor] Data read successfully for key: \(key)")
        return object
    }
    
    /// Thread-safe delete operation
    public func delete(for key: String) async {
        writeQueue.removeValue(forKey: key)
        print("🗑️ [StorageActor] Data deleted for key: \(key)")
    }
    
    /// Batch write operations for efficiency
    public func batchWrite<T: Codable>(_ items: [(T, String)]) async throws {
        print("📦 [StorageActor] Starting batch write for \(items.count) items")
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for (object, key) in items {
                group.addTask {
                    try await self.write(object, for: key)
                }
            }
        }
        
        print("✅ [StorageActor] Batch write completed")
    }
    
    /// Private method to perform actual write
    private func performWrite(_ data: Data, for key: String) async throws {
        // Simulate disk write delay
        try await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        
        // Store in memory queue (in real implementation, this would write to disk)
        writeQueue[key] = data
        
        // Manage queue size
        if writeQueue.count > maxQueueSize {
            let oldestKey = writeQueue.keys.first!
            writeQueue.removeValue(forKey: oldestKey)
            print("🧹 [StorageActor] Removed oldest entry to maintain queue size")
        }
    }
    
    /// Get storage statistics
    public func getStats() -> (pendingWrites: Int, queueSize: Int, totalSize: Int) {
        let totalSize = writeQueue.values.reduce(0) { $0 + $1.count }
        return (pendingWrites.count, writeQueue.count, totalSize)
    }
    
    /// Clear all data
    public func clearAll() {
        writeQueue.removeAll()
        print("🧹 [StorageActor] All data cleared")
    }
}
