import Foundation

class AgentService {
    
    static let shared = AgentService()
    private init() {}
    
    // Entrada principal — recibe el mensaje del usuario
    // y retorna la respuesta del agente vía callback
    func sendMessage(
        _ userMessage: String,
        appState: AppState,
        onUpdate: @escaping (String) -> Void
    ) async {
        // Por ahora simulamos una respuesta del agente
        // Cuando tengamos la API key, aquí va la llamada a Claude
        await MainActor.run { appState.isLoading = true }
        
        // Simula el agente "pensando"
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // Simula una tool call visible en el panel
        let toolCallId = await MainActor.run {
            appState.addToolCall(
                toolName: "analyze_swift_file",
                input: userMessage
            )
        }
        
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        await MainActor.run {
            appState.completeToolCall(
                id: toolCallId,
                output: "Analysis complete — 3 structs, 12 functions found",
                success: true
            )
        }
        
        // Respuesta simulada del agente
        let response = """
        He analizado tu consulta: "\(userMessage)"
        
        Cuando conectemos la API key de Claude, aquí verás la respuesta real del agente usando las tools de MCP.
        
        Tools disponibles:
        • analyze_swift_file
        • search_apple_docs  
        • validate_swiftui_patterns
        • generate_swift_tests
        """
        
        await MainActor.run {
            appState.addMessage(role: .assistant, content: response)
            appState.isLoading = false
        }
    }
}
