#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// A protocol for objects that can process strings
/// Defines the contract for string processing operations
public protocol StringProcessable {
    /// Processes a string and returns a modified version
    /// - Parameter input: The string to process
    /// - Returns: The processed string
    func process(_ input: String) -> String
}

/// Enumeration of possible string processing errors
/// Represents errors that can occur during string processing
public enum StringProcessingError: Error, LocalizedError {
    case emptyString
    case invalidCharacters
    case processingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .emptyString:
            return "Input string cannot be empty"
        case .invalidCharacters:
            return "String contains invalid characters"
        case .processingFailed(let reason):
            return "Processing failed: \(reason)"
        }
    }
}

/// A utility class for string processing operations
/// Provides various string manipulation and analysis functions
public struct StringProcessor: StringProcessable {
    
    /// Reverses the characters in a string
    /// - Parameter input: The string to reverse
    /// - Returns: The reversed string
    /// - Example:
    ///   ```swift
    ///   let processor = StringProcessor()
    ///   let result = processor.reverse("hello") // Returns "olleh"
    ///   ```
    public func reverse(_ input: String) -> String {
        return String(input.reversed())
    }
    
    /// Converts a string to title case
    /// - Parameter input: The string to convert
    /// - Returns: The string in title case
    /// - Example:
    ///   ```swift
    ///   let processor = StringProcessor()
    ///   let result = processor.toTitleCase("hello world") // Returns "Hello World"
    ///   ```
    public func toTitleCase(_ input: String) -> String {
        return input.capitalized
    }
    
    /// Counts the number of vowels in a string
    /// - Parameter input: The string to analyze
    /// - Returns: The number of vowels found
    /// - Example:
    ///   ```swift
    ///   let processor = StringProcessor()
    ///   let count = processor.countVowels("hello") // Returns 2
    ///   ```
    public func countVowels(_ input: String) -> Int {
        let vowels = Set("aeiouAEIOU")
        return input.filter { vowels.contains($0) }.count
    }
    
    /// Removes all whitespace from a string
    /// - Parameter input: The string to process
    /// - Returns: The string with whitespace removed
    /// - Throws: `StringProcessingError.emptyString` if input is empty
    /// - Example:
    ///   ```swift
    ///   let processor = StringProcessor()
    ///   let result = try processor.removeWhitespace("hello world") // Returns "helloworld"
    ///   ```
    public func removeWhitespace(_ input: String) throws -> String {
        guard !input.isEmpty else {
            throw StringProcessingError.emptyString
        }
        
        return input.replacingOccurrences(of: " ", with: "")
    }
    
    /// Implementation of StringProcessable protocol
    /// - Parameter input: The string to process
    /// - Returns: The processed string (reversed and title-cased)
    public func process(_ input: String) -> String {
        return toTitleCase(reverse(input))
    }
}