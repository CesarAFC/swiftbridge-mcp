import SwiftUI

struct ToolTracePanel: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Header
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundColor(.orange)
                Text("Tool Calls")
                    .font(.headline)
                Spacer()
                Text("\(appState.toolCalls.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Lista de tool calls
            if appState.toolCalls.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "wrench.fill")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Las herramientas del agente\naparecerán aquí")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(appState.toolCalls) { toolCall in
                            ToolCallCard(toolCall: toolCall)
                        }
                    }
                    .padding(12)
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
    }
}

// Tarjeta individual de una tool call
struct ToolCallCard: View {
    let toolCall: ToolCall
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Nombre de la tool + estado
            HStack {
                Text(toolCall.toolName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                StatusBadge(status: toolCall.status)
            }
            
            // Input
            Text(toolCall.input)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Output si existe
            if let output = toolCall.output {
                Divider()
                Text(output)
                    .font(.caption2)
                    .foregroundColor(.green)
                    .lineLimit(3)
            }
        }
        .padding(10)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(statusColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var statusColor: Color {
        switch toolCall.status {
        case .running: return .blue
        case .completed: return .green
        case .failed: return .red
        }
    }
}

// Badge de estado
struct StatusBadge: View {
    let status: ToolCallStatus
    
    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(4)
    }
    
    private var label: String {
        switch status {
        case .running: return "running"
        case .completed: return "done"
        case .failed: return "failed"
        }
    }
    
    private var color: Color {
        switch status {
        case .running: return .blue
        case .completed: return .green
        case .failed: return .red
        }
    }
}
