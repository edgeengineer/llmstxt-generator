import Testing
@testable import ExampleLibrary

struct MathUtilsTests {
    
    @Test func add() {
        #expect(MathUtils.add(2, 3) == 5)
        #expect(MathUtils.add(-1, 1) == 0)
        #expect(MathUtils.add(0, 0) == 0)
    }
    
    @Test func multiply() {
        #expect(MathUtils.multiply(3, 4) == 12)
        #expect(MathUtils.multiply(-2, 5) == -10)
        #expect(MathUtils.multiply(0, 100) == 0)
    }
    
    @Test func factorial() throws {
        #expect(try MathUtils.factorial(0) == 1)
        #expect(try MathUtils.factorial(1) == 1)
        #expect(try MathUtils.factorial(5) == 120)
        
        #expect(throws: MathError.self) {
            try MathUtils.factorial(-1)
        }
    }
    
    @Test func isPrime() {
        #expect(MathUtils.isPrime(2))
        #expect(MathUtils.isPrime(17))
        #expect(!MathUtils.isPrime(4))
        #expect(!MathUtils.isPrime(1))
    }
}