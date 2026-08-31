import Foundation

struct AnalyzeSwiftFileTool: MCPTool {
    let name = "analyze_swift_file"
    let description = "Analyzes a Swift source file and returns its structure: types, functions, imports, and potential issues."
    
    func execute(input: [String: String]) async throws -> String {
        guard let filePath = input["file_path"] else {
            throw MCPToolError.missingParameter("file_path")
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw MCPToolError.fileNotFound(filePath)
        }
        
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        // Análisis básico del archivo
        let imports = lines.filter { $0.hasPrefix("import ") }
        let structs = lines.filter { $0.contains("struct ") && $0.contains("{") }
        let classes = lines.filter { $0.contains("class ") && $0.contains("{") }
        let functions = lines.filter { $0.contains("func ") && $0.contains("(") }
        let todos = lines.filter { $0.contains("// TODO") || $0.contains("// FIXME") }
        
        var result = """
        📁 FILE ANALYSIS: \(url.lastPathComponent)
        ─────────────────────────────────
        Lines of code: \(lines.count)
        
        📦 IMPORTS (\(imports.count)):
        \(imports.joined(separator: "\n"))
        
        🏗️ TYPES:
        - Structs: \(structs.count)
        - Classes: \(classes.count)
        
        ⚙️ FUNCTIONS: \(functions.count)
        
        """
        
        if !todos.isEmpty {
            result += """
            ⚠️ TODOs/FIXMEs (\(todos.count)):
            \(todos.joined(separator: "\n"))
            """
        } else {
            result += "✅ No TODOs or FIXMEs found"
        }
        
        return result
    }
}
