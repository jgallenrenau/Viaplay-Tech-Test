import Foundation

/// Manager for controlling concurrent operations with semaphores and rate limiting
@MainActor
public final class ConcurrencyManager: ObservableObject {
    public static let shared = ConcurrencyManager()
    
    @Published public private(set) var activeOperations: Int = 0
    @Published public private(set) var queuedOperations: Int = 0
    
    private let maxConcurrentOperations = 3
    private let semaphore: DispatchSemaphore
    private var operationQueue: [String: Task<Void, Never>] = [:]
    
    private init() {
        self.semaphore = DispatchSemaphore(value: maxConcurrentOperations)
    }
    
    /// Execute operation with concurrency control
    public func execute<T>(
        _ operation: @escaping () async throws -> T,
        id: String = UUID().uuidString
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                await self.acquireSemaphore()
                activeOperations += 1
                
                do {
                    let result = try await operation()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
                
                await self.releaseSemaphore()
                activeOperations -= 1
            }
        }
    }
    
    /// Execute multiple operations with controlled concurrency
    public func executeBatch<T>(
        operations: [(String, () async throws -> T)],
        maxConcurrent: Int? = nil
    ) async throws -> [String: T] {
        let limit = maxConcurrent ?? maxConcurrentOperations
        var results: [String: T] = [:]
        
        await withTaskGroup(of: (String, T?).self) { group in
            var operationIndex = 0
            
            // Start initial batch
            for _ in 0..<min(limit, operations.count) {
                let (id, operation) = operations[operationIndex]
                group.addTask {
                    do {
                        let result = try await self.execute(operation, id: id)
                        return (id, result)
                    } catch {
                        print("❌ [ConcurrencyManager] Operation \(id) failed: \(error)")
                        return (id, nil)
                    }
                }
                operationIndex += 1
            }
            
            // Process results and add new operations
            for await (id, result) in group {
                if let result = result {
                    results[id] = result
                }
                
                // Add next operation if available
                if operationIndex < operations.count {
                    let (nextId, nextOperation) = operations[operationIndex]
                    group.addTask {
                        do {
                            let result = try await self.execute(nextOperation, id: nextId)
                            return (nextId, result)
                        } catch {
                            print("❌ [ConcurrencyManager] Operation \(nextId) failed: \(error)")
                            return (nextId, nil)
                        }
                    }
                    operationIndex += 1
                }
            }
        }
        
        return results
    }
    
    /// Rate-limited execution
    public func executeWithRateLimit<T>(
        _ operation: @escaping () async throws -> T,
        requestsPerSecond: Int = 10
    ) async throws -> T {
        let delay = 1.0 / Double(requestsPerSecond)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        return try await execute(operation)
    }
    
    /// Private method to acquire semaphore
    private func acquireSemaphore() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                self.semaphore.wait()
                continuation.resume()
            }
        }
    }
    
    /// Private method to release semaphore
    private func releaseSemaphore() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                self.semaphore.signal()
                continuation.resume()
            }
        }
    }
    
    /// Cancel all operations
    public func cancelAll() {
        for task in operationQueue.values {
            task.cancel()
        }
        operationQueue.removeAll()
        print("🛑 [ConcurrencyManager] All operations cancelled")
    }
    
    /// Get current statistics
    public var stats: (active: Int, queued: Int, available: Int) {
        let available = maxConcurrentOperations - activeOperations
        return (activeOperations, queuedOperations, max(0, available))
    }
}
