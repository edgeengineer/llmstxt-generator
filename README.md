# LLMSTxtGenerator

[![Swift](https://img.shields.io/badge/swift-6.0-brightgreen.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS%20%7C%20Linux-lightgrey.svg)](https://swift.org)
[![CI](https://github.com/edgeengineer/llmstxt-generator/actions/workflows/swift.yml/badge.svg)](https://github.com/edgeengineer/llmstxt-generator/actions/workflows/swift.yml)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

A Swift Package Plugin that automatically generates `llms.txt` files for Swift packages to provide LLM-friendly documentation.

## Overview

The LLMSTxtGenerator plugin analyzes your Swift package's public API and generates a comprehensive `llms.txt` file that contains structured documentation optimized for Large Language Models. This makes it easier for LLMs to understand and work with your Swift package.

## Features

- ✅ Cross-platform support (macOS, iOS, tvOS, watchOS, visionOS, and Linux)
- ✅ Automatic detection of public APIs
- ✅ Extraction of documentation comments with examples
- ✅ Support for classes, structs, enums, protocols, and functions
- ✅ Clean Swift-style method signatures (e.g., `add(_:_:)`, `create(key:value:)`)
- ✅ Markdown-formatted output optimized for LLMs
- ✅ Swift Testing framework support

## Installation

Add this package as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/edgeengineer/llmstxt-generator.git", from: "1.0.0")
]
```

## Usage

### Running the Plugin

To generate an `llms.txt` file for your Swift package, run the following command in your package directory:

```bash
swift package plugin generate-llms-txt
```

This will create an `llms.txt` file in your package root containing documentation for all public APIs.

### Testing with ExampleLibrary

This repository includes a complete example demonstrating the plugin's capabilities. To test it:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/edgeengineer/llmstxt-generator.git
   cd llmstxt-generator
   ```

2. **Run the tests to verify everything works:**
   ```bash
   swift test
   ```

3. **Generate the llms.txt file:**
   ```bash
   swift package plugin generate-llms-txt
   ```

4. **View the generated documentation:**
   ```bash
   cat llms.txt
   ```

The ExampleLibrary includes:
- **MathUtils**: Mathematical operations (`add`, `multiply`, `factorial`, `isPrime`)
- **StringProcessor**: String manipulation (`reverse`, `toTitleCase`, `countVowels`, etc.)
- **Error types**: `MathError` and `StringProcessingError`
- **Protocols**: `StringProcessable` for processing contracts

### Example Output

The generated `llms.txt` file will contain structured documentation like this:

```markdown
# LLMSTxtGenerator API Documentation

### MathUtils.swift

#### Function: `add(_:_:)`

Calculates the sum of two integers
- Parameters:
  - a: The first integer
  - b: The second integer
- Returns: The sum of a and b
- Example:
  ```swift
  let result = MathUtils.add(5, 3) // Returns 8
  ```

```swift
public static func add(_ a: Int, _ b: Int) -> Int
```

#### Function: `factorial(_:)`

```swift
public static func factorial(_ n: Int) throws -> Int
```
```

### Integration with Your Swift Package

The plugin works by:

1. **Scanning** your `Sources` directory for Swift files
2. **Parsing** Swift source code using regex patterns
3. **Extracting** public declarations and their documentation comments
4. **Generating** a structured markdown file optimized for LLMs

### Supported Declaration Types

- **Classes**: Public class declarations with inheritance information
- **Structs**: Public struct declarations with protocol conformances
- **Enums**: Public enum declarations with associated types
- **Protocols**: Public protocol declarations with requirements
- **Functions**: Public function declarations with proper signatures (e.g., `create(key:value:)`)
- **Variables/Constants**: Public properties with type information

## Requirements

- Swift 6.0 or later
- Supports all Apple platforms (macOS 14+, iOS 17+, tvOS 17+, watchOS 10+, visionOS 1+)
- Linux support included

## Development

### Running Tests

This project uses Swift Testing framework:

```bash
swift test
```

### Building

```bash
swift build
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

This project is available under the Apache 2.0 license. See the LICENSE file for more info.