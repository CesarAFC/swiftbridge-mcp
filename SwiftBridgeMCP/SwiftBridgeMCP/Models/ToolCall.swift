import Foundation

// Estado de ejecución de una herramienta
enum ToolCallStatus {
    case running    // La herramienta está ejecutándose
    case completed  // Terminó exitosamente
    case failed     // Falló
}

// Representa una llamada a una herramienta MCP
// Esto es lo que se muestra en el panel lateral de la app
struct ToolCall: Identifiable {
    let id: UUID
    let toolName: String        // Ej: "analyze_swift_file"
    let input: String           // Qué le pasó el agente
    var output: String?         // Qué retornó la herramienta
    var status: ToolCallStatus
    let timestamp: Date
    
    init(toolName: String, input: String) {
        self.id = UUID()
        self.toolName = toolName
        self.input = input
        self.status = .running
        self.timestamp = Date()
    }
}
