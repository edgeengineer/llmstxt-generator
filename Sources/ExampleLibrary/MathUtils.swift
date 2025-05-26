#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// A utility class for mathematical operations
/// Provides common mathematical functions with enhanced features
public class MathUtils {
    
    /// Calculates the sum of two integers
    /// - Parameters:
    ///   - a: The first integer
    ///   - b: The second integer
    /// - Returns: The sum of a and b
    /// - Example:
    ///   ```swift
    ///   let result = MathUtils.add(5, 3) // Returns 8
    ///   ```
    public static func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    /// Multiplies two integers together
    /// - Parameters:
    ///   - a: The first integer
    ///   - b: The second integer
    /// - Returns: The product of a and b
    /// - Example:
    ///   ```swift
    ///   let result = MathUtils.multiply(4, 7) // Returns 28
    ///   ```
    public static func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
    
    /// Calculates the factorial of a non-negative integer
    /// - Parameter n: A non-negative integer
    /// - Returns: The factorial of n
    /// - Throws: `MathError.invalidInput` if n is negative
    /// - Example:
    ///   ```swift
    ///   let result = try MathUtils.factorial(5) // Returns 120
    ///   ```
    public static func factorial(_ n: Int) throws -> Int {
        guard n >= 0 else {
            throw MathError.invalidInput("Factorial is not defined for negative numbers")
        }
        
        if n <= 1 {
            return 1
        }
        
        return n * (try factorial(n - 1))
    }
    
    /// Checks if a number is prime
    /// - Parameter number: The integer to check
    /// - Returns: True if the number is prime, false otherwise
    /// - Example:
    ///   ```swift
    ///   let isPrime = MathUtils.isPrime(17) // Returns true
    ///   ```
    public static func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        guard number > 3 else { return true }
        guard number % 2 != 0 && number % 3 != 0 else { return false }
        
        var i = 5
        while i * i <= number {
            if number % i == 0 || number % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
}