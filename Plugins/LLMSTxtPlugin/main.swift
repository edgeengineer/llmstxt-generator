#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import PackagePlugin

@main
struct LLMSTxtPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let packageDirectory = context.package.directory
        let outputPath = packageDirectory.appending(subpath: "llms.txt")
        
        print("Generating llms.txt for package at: \(packageDirectory)")
        
        let sourceFiles = findSwiftFiles(in: packageDirectory)
        let documentation = generateDocumentation(from: sourceFiles, packageName: context.package.displayName, packageDirectory: packageDirectory)
        
        try documentation.write(to: URL(fileURLWithPath: outputPath.string), atomically: true, encoding: .utf8)
        
        print("Successfully generated llms.txt at: \(outputPath)")
    }
    
    private func findSwiftFiles(in directory: Path) -> [Path] {
        var swiftFiles: [Path] = []
        
        func searchDirectory(_ dir: Path) {
            guard let enumerator = FileManager.default.enumerator(atPath: dir.string) else { return }
            
            for case let file as String in enumerator {
                let filePath = dir.appending(subpath: file)
                if file.hasSuffix(".swift") && !file.contains("/.build/") && !file.contains("/Tests/") {
                    swiftFiles.append(filePath)
                }
            }
        }
        
        searchDirectory(directory.appending(subpath: "Sources"))
        return swiftFiles
    }
    
    private func generateDocumentation(from files: [Path], packageName: String, packageDirectory: Path) -> String {
        let packageMetadata = extractPackageMetadata(from: packageDirectory)
        
        var documentation = """
        # \(packageName) API Documentation
        
        This file provides LLM-friendly documentation for the \(packageName) Swift package.
        
        ## Package Information
        
        """
        
        if !packageMetadata.isEmpty {
            for (key, value) in packageMetadata {
                documentation += "- **\(key)**: \(value)\n"
            }
            documentation += "\n"
        }
        
        documentation += """
        ## Overview
        
        This package provides the following public APIs:
        
        """
        
        for file in files {
            do {
                let fileContent = try String(contentsOfFile: file.string)
                let publicDeclarations = extractPublicDeclarations(from: fileContent)
                
                if !publicDeclarations.isEmpty {
                    documentation += "\n### \(file.lastComponent)\n\n"
                    
                    for declaration in publicDeclarations {
                        documentation += declaration + "\n\n"
                    }
                }
            } catch {
                print("Error reading file \(file): \(error)")
            }
        }
        
        documentation += """
        
        ## Usage Examples
        
        For detailed usage examples, refer to the test files and documentation comments in the source code.
        
        ## License
        
        Please refer to the LICENSE file in the repository for licensing information.
        """
        
        return documentation
    }
    
    private func extractPublicDeclarations(from content: String) -> [String] {
        var declarations: [String] = []
        let lines = content.components(separatedBy: .newlines)
        
        var currentDocComment: [String] = []
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            // Collect documentation comments
            if trimmedLine.hasPrefix("/// ") {
                currentDocComment.append(String(trimmedLine.dropFirst(4)))
                continue
            }
            
            // Look for public declarations
            if trimmedLine.hasPrefix("public ") {
                let declarationType = getDeclarationType(from: trimmedLine)
                let declarationName = getDeclarationName(from: trimmedLine)
                let cleanDeclaration = cleanDeclarationLine(trimmedLine)
                
                var formattedDeclaration = "#### \(declarationType): `\(declarationName)`\n"
                
                if !currentDocComment.isEmpty {
                    formattedDeclaration += "\n" + currentDocComment.joined(separator: "\n") + "\n"
                }
                
                formattedDeclaration += "\n```swift\n\(cleanDeclaration)\n```"
                
                declarations.append(formattedDeclaration)
                currentDocComment.removeAll()
            } else if !trimmedLine.hasPrefix("/// ") && !trimmedLine.isEmpty {
                // Reset doc comment if we hit a non-comment, non-empty line
                currentDocComment.removeAll()
            }
        }
        
        return declarations
    }
    
    private func getDeclarationType(from line: String) -> String {
        if line.contains("actor ") { return "Actor" }
        if line.contains("class ") { return "Class" }
        if line.contains("struct ") { return "Struct" }
        if line.contains("enum ") { return "Enum" }
        if line.contains("protocol ") { return "Protocol" }
        if line.contains("func ") { return "Function" }
        if line.contains("var ") { return "Variable" }
        if line.contains("let ") { return "Constant" }
        if line.contains("typealias ") { return "Type Alias" }
        if line.contains("extension ") { return "Extension" }
        return "Declaration"
    }
    
    private func getDeclarationName(from line: String) -> String {
        let trimmedLine = line.trimmingCharacters(in: .whitespaces)
        
        // Handle functions specially to extract full signature
        if trimmedLine.contains("func ") {
            return extractFunctionSignature(from: trimmedLine)
        }
        
        let components = line.components(separatedBy: " ")
        
        // Find the name after the declaration keyword
        for i in 0..<components.count {
            if ["actor", "class", "struct", "enum", "protocol", "var", "let", "typealias", "extension"].contains(components[i]) && i + 1 < components.count {
                let name = components[i + 1]
                // Remove type annotations for variables
                if let colonIndex = name.firstIndex(of: ":") {
                    return String(name[..<colonIndex])
                }
                return name
            }
        }
        
        return "Unknown"
    }
    
    private func extractFunctionSignature(from line: String) -> String {
        // Extract function name and parameters
        guard let funcRange = line.range(of: "func ") else { return "Unknown" }
        let afterFunc = String(line[funcRange.upperBound...])
        
        // Find the function name (everything up to the opening parenthesis)
        guard let openParenIndex = afterFunc.firstIndex(of: "(") else {
            // No parameters
            let funcName = afterFunc.components(separatedBy: " ").first ?? "Unknown"
            return funcName
        }
        
        let funcName = String(afterFunc[..<openParenIndex])
        
        // Extract parameters between parentheses
        guard let closeParenIndex = afterFunc.firstIndex(of: ")") else { return funcName }
        let paramString = String(afterFunc[afterFunc.index(after: openParenIndex)..<closeParenIndex])
        
        // Parse parameters to extract labels
        if paramString.trimmingCharacters(in: .whitespaces).isEmpty {
            return "\(funcName)()"
        }
        
        let parameters = paramString.components(separatedBy: ",")
        var paramLabels: [String] = []
        
        for param in parameters {
            let trimmedParam = param.trimmingCharacters(in: .whitespaces)
            let components = trimmedParam.components(separatedBy: " ")
            
            if let firstComponent = components.first, !firstComponent.isEmpty {
                // Handle external parameter labels
                if firstComponent == "_" {
                    paramLabels.append("_")
                } else if components.count > 1 && !firstComponent.hasSuffix(":") {
                    // External label exists
                    paramLabels.append("\(firstComponent):")
                } else if firstComponent.hasSuffix(":") {
                    // No external label, use internal label
                    paramLabels.append(firstComponent)
                } else {
                    // Simple parameter name
                    paramLabels.append("\(firstComponent):")
                }
            }
        }
        
        return "\(funcName)(\(paramLabels.joined(separator: "")))"
    }
    
    private func cleanDeclarationLine(_ line: String) -> String {
        var cleanLine = line.trimmingCharacters(in: .whitespaces)
        
        // Remove opening braces and everything after them
        if let braceIndex = cleanLine.firstIndex(of: "{") {
            cleanLine = String(cleanLine[..<braceIndex]).trimmingCharacters(in: .whitespaces)
        }
        
        // For functions, clean up to just the signature
        if cleanLine.contains("func ") {
            // Find the end of the function signature
            var parenCount = 0
            var inParens = false
            var endIndex = cleanLine.endIndex
            
            for (index, char) in cleanLine.enumerated() {
                if char == "(" {
                    inParens = true
                    parenCount += 1
                } else if char == ")" {
                    parenCount -= 1
                    if parenCount == 0 && inParens {
                        // Found the end of parameters, look for throws/return type
                        let remainingString = String(cleanLine[cleanLine.index(cleanLine.startIndex, offsetBy: index + 1)...])
                        let throwsPattern = remainingString.range(of: #"\s*(throws|rethrows)?\s*(->\s*\w+[\w\s<>,]*)?(?=\s*\{|$)"#, options: .regularExpression)
                        if let throwsRange = throwsPattern {
                            let fullEndIndex = cleanLine.index(cleanLine.startIndex, offsetBy: index + 1 + throwsRange.upperBound.utf16Offset(in: remainingString))
                            endIndex = fullEndIndex
                        } else {
                            endIndex = cleanLine.index(cleanLine.startIndex, offsetBy: index + 1)
                        }
                        break
                    }
                }
            }
            
            cleanLine = String(cleanLine[..<endIndex]).trimmingCharacters(in: .whitespaces)
        }
        
        return cleanLine
    }
    
    private func extractPackageMetadata(from packageDirectory: Path) -> [String: String] {
        var metadata: [String: String] = [:]
        
        let packageSwiftPath = packageDirectory.appending(subpath: "Package.swift")
        
        do {
            let packageContent = try String(contentsOfFile: packageSwiftPath.string)
            
            // Extract package name
            if let nameMatch = packageContent.range(of: #"name:\s*"([^"]+)""#, options: .regularExpression) {
                let nameString = String(packageContent[nameMatch])
                if let nameValue = nameString.range(of: #""([^"]+)""#, options: .regularExpression) {
                    let name = String(nameString[nameValue]).replacingOccurrences(of: "\"", with: "")
                    metadata["Package Name"] = name
                }
            }
            
            // Extract Swift tools version
            if let versionMatch = packageContent.range(of: #"swift-tools-version:\s*([0-9.]+)"#, options: .regularExpression) {
                let versionString = String(packageContent[versionMatch])
                if let version = versionString.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) {
                    metadata["Swift Tools Version"] = version
                }
            }
            
            // Extract platforms
            let platformPatterns = [
                ("macOS", #"\.macOS\(\.v([0-9_]+)\)"#),
                ("iOS", #"\.iOS\(\.v([0-9_]+)\)"#),
                ("tvOS", #"\.tvOS\(\.v([0-9_]+)\)"#),
                ("watchOS", #"\.watchOS\(\.v([0-9_]+)\)"#),
                ("visionOS", #"\.visionOS\(\.v([0-9_]+)\)"#)
            ]
            
            var supportedPlatforms: [String] = []
            for (platform, pattern) in platformPatterns {
                if let match = packageContent.range(of: pattern, options: .regularExpression) {
                    let matchString = String(packageContent[match])
                    if let versionMatch = matchString.range(of: #"v([0-9_]+)"#, options: .regularExpression) {
                        let version = String(matchString[versionMatch]).replacingOccurrences(of: "v", with: "").replacingOccurrences(of: "_", with: ".")
                        supportedPlatforms.append("\(platform) \(version)+")
                    } else {
                        supportedPlatforms.append(platform)
                    }
                }
            }
            
            if !supportedPlatforms.isEmpty {
                metadata["Supported Platforms"] = supportedPlatforms.joined(separator: ", ")
            }
            
            // Extract simple patterns without ranges
            if packageContent.contains(".library(") {
                metadata["Products"] = "Swift Library"
            }
            if packageContent.contains(".plugin(") {
                metadata["Products"] = metadata["Products"] == nil ? "Swift Plugin" : "Swift Library, Swift Plugin"
            }
            
            if packageContent.contains("swift-syntax") {
                metadata["Dependencies"] = "swift-syntax"
            }
            
        } catch {
            print("Warning: Could not read Package.swift: \(error)")
        }
        
        // Add generation timestamp
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        metadata["Generated"] = formatter.string(from: Date())
        
        return metadata
    }
}