import Foundation
import Combine

// ObservableObject es como un store de Zustand/Redux
// Cuando cambia, SwiftUI re-renderiza automáticamente las vistas
class AppState: ObservableObject {
    // @Published = cada vez que cambia, la UI se actualiza
    @Published var messages: [Message] = []
    @Published var toolCalls: [ToolCall] = []
    @Published var isLoading: Bool = false
    @Published var inputText: String = ""
    
    // Agrega un mensaje al chat
    func addMessage(role: MessageRole, content: String) {
        let message = Message(role: role, content: content)
        messages.append(message)
    }
    
    // Agrega una tool call al panel lateral
    func addToolCall(toolName: String, input: String) -> UUID {
        let toolCall = ToolCall(toolName: toolName, input: input)
        toolCalls.append(toolCall)
        return toolCall.id
    }
    
    // Actualiza el resultado de una tool call
    func completeToolCall(id: UUID, output: String, success: Bool) {
        if let index = toolCalls.firstIndex(where: { $0.id == id }) {
            toolCalls[index].output = output
            toolCalls[index].status = success ? .completed : .failed
        }
    }
}
