import Foundation

// Protocol base que todas las tools deben cumplir
// Como una interface en TypeScript
protocol MCPTool {
    var name: String { get }
    var description: String { get }
    func execute(input: [String: String]) async throws -> String
}

// Errores posibles al ejecutar una tool
enum MCPToolError: Error, LocalizedError {
    case missingParameter(String)
    case fileNotFound(String)
    case executionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .missingParameter(let param):
            return "Parámetro requerido no encontrado: \(param)"
        case .fileNotFound(let path):
            return "Archivo no encontrado: \(path)"
        case .executionFailed(let reason):
            return "La tool falló: \(reason)"
        }
    }
}
