import Foundation

// Representa quién envió el mensaje
enum MessageRole: String, Codable {
    case user       // El desarrollador que usa la app
    case assistant  // El agente de IA (Claude)
    case tool       // Resultado de una herramienta MCP
}

// Un mensaje en el chat
struct Message: Identifiable, Codable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    init(role: MessageRole, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
}
