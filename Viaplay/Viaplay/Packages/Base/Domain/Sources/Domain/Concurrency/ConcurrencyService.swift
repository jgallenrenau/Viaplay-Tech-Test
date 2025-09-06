import Foundation

/// Service for managing concurrent operations and task coordination
@MainActor
public final class ConcurrencyService: ObservableObject {
    public static let shared = ConcurrencyService()
    
    @Published public private(set) var activeTasks: Set<String> = []
    @Published public private(set) var completedTasks: Set<String> = []
    
    private var taskGroups: [String: TaskGroup<Void, Never>] = [:]
    
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
            var operationIndex = 0
            
            // Start initial batch
            for _ in 0..<min(maxConcurrent, operations.count) {
                group.addTask {
                    try await operations[operationIndex]()
                }
                operationIndex += 1
            }
            
            // Process results and add new tasks as needed
            for try await result in group {
                results.append(result)
                
                // Add next operation if available
                if operationIndex < operations.count {
                    group.addTask {
                        try await operations[operationIndex]()
                    }
                    operationIndex += 1
                }
            }
            
            return results
        }
    }
    
    /// Cancel all active tasks
    public func cancelAllTasks() {
        for groupId in activeTasks {
            taskGroups[groupId]?.cancelAll()
        }
        activeTasks.removeAll()
    }
    
    /// Get concurrency statistics
    public var stats: (active: Int, completed: Int) {
        return (activeTasks.count, completedTasks.count)
    }
}
