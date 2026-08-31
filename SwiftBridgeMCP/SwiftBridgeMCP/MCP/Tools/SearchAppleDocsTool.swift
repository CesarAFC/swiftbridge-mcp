import Foundation

struct SearchAppleDocsTool: MCPTool {
    let name = "search_apple_docs"
    let description = "Searches Apple Developer Documentation for Swift APIs, frameworks, and best practices."
    
    func execute(input: [String: String]) async throws -> String {
        guard let query = input["query"] else {
            throw MCPToolError.missingParameter("query")
        }
        
        // Apple tiene una API pública de búsqueda de documentación
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://developer.apple.com/search/search-data.php?q=\(encodedQuery)&type=Documentation"
        
        guard let url = URL(string: urlString) else {
            throw MCPToolError.executionFailed("Invalid search URL")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let results = json["results"] as? [[String: Any]] else {
            return "No results found for: \(query)"
        }
        
        let topResults = results.prefix(5)
        var output = "📚 APPLE DOCS — \"\(query)\"\n"
        output += "─────────────────────────────────\n"
        
        for (index, result) in topResults.enumerated() {
            let title = result["title"] as? String ?? "Unknown"
            let description = result["description"] as? String ?? ""
            let path = result["url"] as? String ?? ""
            
            output += "\n\(index + 1). \(title)\n"
            if !description.isEmpty {
                output += "   \(description)\n"
            }
            if !path.isEmpty {
                output += "   🔗 developer.apple.com\(path)\n"
            }
        }
        
        return output
    }
}
