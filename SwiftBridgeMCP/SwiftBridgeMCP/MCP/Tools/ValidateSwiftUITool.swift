import Foundation

struct ValidateSwiftUITool: MCPTool {
    let name = "validate_swiftui_patterns"
    let description = "Validates a SwiftUI file against Apple's recommended patterns and detects common anti-patterns."
    
    func execute(input: [String: String]) async throws -> String {
        guard let filePath = input["file_path"] else {
            throw MCPToolError.missingParameter("file_path")
        }
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw MCPToolError.fileNotFound(filePath)
        }
        
        let url = URL(fileURLWithPath: filePath)
        let content = try String(contentsOf: url, encoding: .utf8)
        
        var issues: [String] = []
        var suggestions: [String] = []
        
        // Anti-pattern: @StateObject usado con @ObservedObject
        if content.contains("@StateObject") && content.contains("@ObservedObject") {
            suggestions.append("✅ Uses both @StateObject and @ObservedObject — verify ownership is correct")
        }
        
        // Anti-pattern: lógica compleja dentro de body
        if content.contains("var body") {
            let bodySection = content.components(separatedBy: "var body").last ?? ""
            if bodySection.components(separatedBy: .newlines).count > 60 {
                issues.append("⚠️ View body seems large — consider breaking into smaller subviews")
            }
        }
        
        // Anti-pattern: sin accessibility labels en elementos interactivos
        if content.contains("Button(") && !content.contains("accessibilityLabel") {
            issues.append("⚠️ Buttons found without accessibilityLabel — consider adding for VoiceOver support")
        }
        
        // Buena práctica: uso de environment
        if content.contains("@Environment") {
            suggestions.append("✅ Uses @Environment — good pattern for dependency injection")
        }
        
        // Anti-pattern: magic numbers en layout
        let numberPattern = #"\.frame\(width: \d{3,}"#
        if content.range(of: numberPattern, options: .regularExpression) != nil {
            issues.append("⚠️ Hardcoded large frame values detected — consider using relative sizing")
        }
        
        // Buena práctica: preview
        if content.contains("#Preview") || content.contains("PreviewProvider") {
            suggestions.append("✅ Has preview — good for iterative UI development")
        } else {
            issues.append("⚠️ No preview found — consider adding #Preview for faster iteration")
        }
        
        var result = "🔍 SWIFTUI VALIDATION\n"
        result += "─────────────────────────────────\n"
        
        if issues.isEmpty && suggestions.isEmpty {
            result += "✅ No issues found"
        } else {
            if !issues.isEmpty {
                result += "\nISSUES (\(issues.count)):\n"
                result += issues.joined(separator: "\n")
            }
            if !suggestions.isEmpty {
                result += "\n\nSUGGESTIONS:\n"
                result += suggestions.joined(separator: "\n")
            }
        }
        
        return result
    }
}
