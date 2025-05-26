#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// Enumeration of mathematical operation errors
/// Represents errors that can occur during mathematical computations
public enum MathError: Error, LocalizedError {
    case invalidInput(String)
    case divisionByZero
    case overflow
    case underflow
    
    /// Provides a localized description of the error
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .divisionByZero:
            return "Division by zero is not allowed"
        case .overflow:
            return "Numerical overflow occurred"
        case .underflow:
            return "Numerical underflow occurred"
        }
    }
}