import SwiftUI

struct ContentView: View {
    // @StateObject es como useState en React pero para objetos complejos
    // AppState maneja toda la data de la app — lo crearemos después
    @StateObject private var appState = AppState()
    
    var body: some View {
        // HSplitView divide la ventana en dos paneles lado a lado
        HSplitView {
            // Panel izquierdo: el chat
            ChatView(appState: appState)
                .frame(minWidth: 400)
            
            // Panel derecho: las tool calls del agente
            ToolTracePanel(appState: appState)
                .frame(minWidth: 280, maxWidth: 360)
        }
        .frame(minWidth: 720, minHeight: 520)
    }
}
