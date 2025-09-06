import Foundation

/// Service for managing concurrent operations and task coordination
@MainActor
public final class ConcurrencyService: ObservableObject {
    public static let shared = ConcurrencyService()
    
    @Published public private(set) var activeTasks: Set<String> = []
    @Published public private(set) var completedTasks: Set<String> = []
    
    private var taskGroups: [String: Task<Void, Never>] = [:]
    
    private init() {}
    
    /// Execute multiple operations concurrently with progress tracking
    public func executeConcurrent<T>(
        operations: [() async throws -> T],
        groupId: String = UUID().uuidString
    ) async throws -> [T] {
        activeTasks.insert(groupId)
        defer {
            activeTasks.remove(groupId)
            completedTasks.insert(groupId)
        }
        
        return try await withThrowingTaskGroup(of: T.self) { group in
            // Add all operations to the group
            for operation in operations {
                group.addTask {
                    try await operation()
                }
            }
            
            // Collect results as they complete
            var results: [T] = []
            for try await result in group {
                results.append(result)
            }
            
            return results
        }
    }
    
    /// Execute operations with limited concurrency
    public func executeWithLimit<T>(
        operations: [() async throws -> T],
        maxConcurrent: Int = 3,
        groupId: String = UUID().uuidString
    ) async throws -> [T] {
        activeTasks.insert(groupId)
        defer {
            activeTasks.remove(groupId)
            completedTasks.insert(groupId)
        }
        
        return try await withThrowingTaskGroup(of: T.self) { group in
            var results: [T] = []
            
            // Use a thread-safe counter for operation index
            let operationCounter = OperationCounter(total: operations.count)
            
            // Start initial batch
            for i in 0..<min(maxConcurrent, operations.count) {
                group.addTask {
                    try await operations[i]()
                }
            }
            
            // Process results and add new tasks as needed
            for try await result in group {
                results.append(result)
                
                // Add next operation if available using thread-safe counter
                if let nextIndex = await operationCounter.getNextIndex() {
                    group.addTask {
                        try await operations[nextIndex]()
                    }
                }
            }
            
            return results
        }
    }
    
    /// Cancel all active tasks
    public func cancelAllTasks() {
        for task in taskGroups.values {
            task.cancel()
        }
        taskGroups.removeAll()
        activeTasks.removeAll()
    }
    
    /// Get concurrency statistics
    public var stats: (active: Int, completed: Int) {
        return (activeTasks.count, completedTasks.count)
    }
}

// MARK: - Thread-Safe Operation Counter

/// Thread-safe counter for managing operation indices in concurrent contexts
private actor OperationCounter {
    private var currentIndex: Int
    private let totalCount: Int
    
    init(total: Int) {
        self.currentIndex = 0
        self.totalCount = total
    }
    
    func getNextIndex() -> Int? {
        guard currentIndex < totalCount else { return nil }
        let index = currentIndex
        currentIndex += 1
        return index
    }
}
