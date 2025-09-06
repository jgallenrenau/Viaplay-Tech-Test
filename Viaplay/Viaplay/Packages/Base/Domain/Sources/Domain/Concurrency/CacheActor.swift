import Foundation

/// Actor for thread-safe cache operations
@globalActor
public actor CacheActor {
    public static let shared = CacheActor()
    
    private var cache: [String: Any] = [:]
    private var prefetchTasks: [String: Task<Void, Never>] = [:]
    
    private init() {}
    
    /// Thread-safe cache get operation
    public func get<T>(_ key: String, as type: T.Type) -> T? {
        return cache[key] as? T
    }
    
    /// Thread-safe cache set operation
    public func set<T>(_ value: T, for key: String) {
        cache[key] = value
    }
    
    /// Thread-safe cache remove operation
    public func remove(_ key: String) {
        cache.removeValue(forKey: key)
    }
    
    /// Start prefetch task for a key
    public func startPrefetch(for key: String, task: @escaping () async -> Void) {
        // Cancel existing task if any
        prefetchTasks[key]?.cancel()
        
        // Start new prefetch task
        prefetchTasks[key] = Task {
            await task()
        }
    }
    
    /// Cancel prefetch task for a key
    public func cancelPrefetch(for key: String) {
        prefetchTasks[key]?.cancel()
        prefetchTasks.removeValue(forKey: key)
    }
    
    /// Cancel all prefetch tasks
    public func cancelAllPrefetches() {
        for task in prefetchTasks.values {
            task.cancel()
        }
        prefetchTasks.removeAll()
    }
    
    /// Get cache statistics
    public func getStats() -> (count: Int, keys: [String]) {
        return (cache.count, Array(cache.keys))
    }
}
