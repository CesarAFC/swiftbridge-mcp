import Foundation

// El servidor MCP — registra todas las tools y maneja su ejecución
// Este es el core del proyecto: implementa el Model Context Protocol
actor MCPServer {
    
    // Registro de tools disponibles — diccionario nombre → tool
    private var tools: [String: any MCPTool] = [:]
    
    // Singleton — una sola instancia en toda la app
    static let shared = MCPServer()
    
    private init() {
        Task { await registerTools() }
    }
    
    // Registra todas las tools disponibles
    private func registerTools() {
        let availableTools: [any MCPTool] = [
            AnalyzeSwiftFileTool(),
            SearchAppleDocsTool(),
            ValidateSwiftUITool(),
            GenerateTestsTool()
        ]
        
        for tool in availableTools {
            tools[tool.name] = tool
        }
    }
    
    // Lista las tools disponibles (lo que el agente ve)
    func listTools() -> [ToolDefinition] {
        tools.values.map { tool in
            ToolDefinition(name: tool.name, description: tool.description)
        }
    }
    
    // Ejecuta una tool por nombre
    func executeTool(name: String, input: [String: String]) async throws -> String {
        guard let tool = tools[name] else {
            throw MCPToolError.executionFailed("Tool '\(name)' not found")
        }
        return try await tool.execute(input: input)
    }
}

// Descripción de una tool para enviarle al modelo de IA
struct ToolDefinition: Codable {
    let name: String
    let description: String
}
