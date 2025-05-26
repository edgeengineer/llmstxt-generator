import Testing
@testable import ExampleLibrary

struct StringProcessorTests {
    
    @Test func reverse() {
        let processor = StringProcessor()
        #expect(processor.reverse("hello") == "olleh")
        #expect(processor.reverse("") == "")
        #expect(processor.reverse("a") == "a")
    }
    
    @Test func toTitleCase() {
        let processor = StringProcessor()
        #expect(processor.toTitleCase("hello world") == "Hello World")
        #expect(processor.toTitleCase("swift testing") == "Swift Testing")
        #expect(processor.toTitleCase("") == "")
    }
    
    @Test func countVowels() {
        let processor = StringProcessor()
        #expect(processor.countVowels("hello") == 2)
        #expect(processor.countVowels("aeiou") == 5)
        #expect(processor.countVowels("bcdfg") == 0)
        #expect(processor.countVowels("") == 0)
    }
    
    @Test func removeWhitespace() throws {
        let processor = StringProcessor()
        #expect(try processor.removeWhitespace("hello world") == "helloworld")
        #expect(try processor.removeWhitespace("no spaces") == "nospaces")
        
        #expect(throws: StringProcessingError.self) {
            try processor.removeWhitespace("")
        }
    }
    
    @Test func process() {
        let processor = StringProcessor()
        #expect(processor.process("hello") == "Olleh")
        #expect(processor.process("world") == "Dlrow")
    }
}