import Foundation

/// Actor for thread-safe network operations and caching
@globalActor
public actor NetworkActor {
    public static let shared = NetworkActor()
    
    private var activeRequests: [String: Task<Data, Error>] = [:]
    private var cache: [String: (data: Data, timestamp: Date)] = [:]
    private let cacheExpiration: TimeInterval = 300 // 5 minutes
    
    private init() {}
    
    /// Thread-safe network request with deduplication
    public func request(url: URL, headers: [String: String] = [:]) async throws -> Data {
        let cacheKey = url.absoluteString
        
        // Check if request is already in progress
        if let existingTask = activeRequests[cacheKey] {
            print("🔄 [NetworkActor] Reusing existing request for: \(url)")
            return try await existingTask.value
        }
        
        // Check cache first
        if let cached = cache[cacheKey], 
           Date().timeIntervalSince(cached.timestamp) < cacheExpiration {
            print("💾 [NetworkActor] Using cached data for: \(url)")
            return cached.data
        }
        
        // Create new request
        let task = Task<Data, Error> {
            print("🌐 [NetworkActor] Making new request to: \(url)")
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        
        activeRequests[cacheKey] = task
        defer {
            activeRequests.removeValue(forKey: cacheKey)
        }
        
        do {
            let data = try await task.value
            
            // Cache the result
            cache[cacheKey] = (data: data, timestamp: Date())
            print("✅ [NetworkActor] Request completed and cached for: \(url)")
            
            return data
        } catch {
            print("❌ [NetworkActor] Request failed for \(url): \(error)")
            throw error
        }
    }
    
    /// Thread-safe cache operations
    public func getCachedData(for key: String) -> Data? {
        guard let cached = cache[key],
              Date().timeIntervalSince(cached.timestamp) < cacheExpiration else {
            return nil
        }
        return cached.data
    }
    
    /// Thread-safe cache storage
    public func setCachedData(_ data: Data, for key: String) {
        cache[key] = (data: data, timestamp: Date())
        print("💾 [NetworkActor] Data cached for key: \(key)")
    }
    
    /// Clear expired cache entries
    public func clearExpiredCache() {
        let now = Date()
        cache = cache.filter { _, value in
            now.timeIntervalSince(value.timestamp) < cacheExpiration
        }
        print("🧹 [NetworkActor] Expired cache entries cleared")
    }
    
    /// Cancel all active requests
    public func cancelAllRequests() {
        for task in activeRequests.values {
            task.cancel()
        }
        activeRequests.removeAll()
        print("🛑 [NetworkActor] All active requests cancelled")
    }
    
    /// Get cache statistics
    public func getCacheStats() -> (count: Int, size: Int) {
        let totalSize = cache.values.reduce(0) { $0 + $1.data.count }
        return (cache.count, totalSize)
    }
}
