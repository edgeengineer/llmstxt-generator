#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// A thread-safe data manager using Swift's actor model
/// Provides safe concurrent access to shared data storage
public actor DataManager {
    
    private var storage: [String: any Sendable] = [:]
    private var accessCount: Int = 0
    
    /// Stores a value with the given key
    /// - Parameters:
    ///   - value: The value to store
    ///   - key: The key to associate with the value
    /// - Example:
    ///   ```swift
    ///   let manager = DataManager()
    ///   await manager.setValue("Hello", forKey: "greeting")
    ///   ```
    public func setValue(_ value: any Sendable, forKey key: String) {
        storage[key] = value
        accessCount += 1
    }
    
    /// Retrieves a value for the given key
    /// - Parameter key: The key to look up
    /// - Returns: The value associated with the key, or nil if not found
    /// - Example:
    ///   ```swift
    ///   let manager = DataManager()
    ///   let value = await manager.getValue(forKey: "greeting")
    ///   ```
    public func getValue(forKey key: String) -> (any Sendable)? {
        accessCount += 1
        return storage[key]
    }
    
    /// Removes a value for the given key
    /// - Parameter key: The key to remove
    /// - Returns: The removed value, or nil if the key wasn't found
    public func removeValue(forKey key: String) -> (any Sendable)? {
        accessCount += 1
        return storage.removeValue(forKey: key)
    }
    
    /// Gets the current number of stored items
    /// - Returns: The count of stored key-value pairs
    public func getStorageCount() -> Int {
        return storage.count
    }
    
    /// Gets the total number of access operations performed
    /// - Returns: The total access count
    public func getAccessCount() -> Int {
        return accessCount
    }
    
    /// Clears all stored data
    /// - Example:
    ///   ```swift
    ///   let manager = DataManager()
    ///   await manager.clearAll()
    ///   ```
    public func clearAll() {
        storage.removeAll()
        accessCount += 1
    }
}