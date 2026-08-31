import SwiftUI

struct ChatView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            HStack {
                Image(systemName: "swift")
                    .foregroundColor(.orange)
                Text("SwiftBridge MCP")
                    .font(.headline)
                Spacer()
                if appState.isLoading {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Lista de mensajes
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(appState.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                // Scroll automático al último mensaje
                .onChange(of: appState.messages.count) { _ in
                    if let last = appState.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Input del usuario
            HStack(spacing: 10) {
                TextField("Pregunta sobre tu código Swift...", text: $appState.inputText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { sendMessage() }
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(appState.inputText.isEmpty ? .gray : .blue)
                }
                .disabled(appState.inputText.isEmpty || appState.isLoading)
                .buttonStyle(.plain)
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !appState.inputText.isEmpty else { return }
        let text = appState.inputText
        appState.addMessage(role: .user, content: text)
        appState.inputText = ""
        
        Task {
            await AgentService.shared.sendMessage(
                text,
                appState: appState,
                onUpdate: { _ in }
            )
        }
    }
}

// Burbuja individual de mensaje
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Avatar
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 20)
            
            // Contenido
            VStack(alignment: .leading, spacing: 4) {
                Text(roleLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(message.content)
                    .font(.body)
                    .textSelection(.enabled)
            }
            Spacer()
        }
    }
    
    private var iconName: String {
        switch message.role {
        case .user: return "person.circle.fill"
        case .assistant: return "cpu.fill"
        case .tool: return "wrench.fill"
        }
    }
    
    private var iconColor: Color {
        switch message.role {
        case .user: return .blue
        case .assistant: return .purple
        case .tool: return .orange
        }
    }
    
    private var roleLabel: String {
        switch message.role {
        case .user: return "Tú"
        case .assistant: return "SwiftBridge"
        case .tool: return "Tool"
        }
    }
}
