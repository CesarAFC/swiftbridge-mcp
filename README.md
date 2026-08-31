# SwiftBridge MCP

> A macOS AI agent for Swift developers — built on the Model Context Protocol (MCP) with Claude API integration.

![Platform](https://img.shields.io/badge/platform-macOS-black?logo=apple)
![Language](https://img.shields.io/badge/language-Swift-orange?logo=swift)
![Protocol](https://img.shields.io/badge/protocol-MCP-6b6bff)
![Status](https://img.shields.io/badge/status-in%20development-yellow)

---

## What is this?

SwiftBridge MCP is a native macOS application that gives developers an AI agent specifically designed for Swift and Apple platform development. Instead of context-switching between Xcode, Apple Developer Documentation, and a generic AI chat, SwiftBridge brings intelligent, tool-powered assistance directly into a single macOS-native interface.

The agent uses the **Model Context Protocol (MCP)** — the open standard for connecting AI models to external tools — so it can take real actions: reading your Swift files, searching Apple's documentation, validating SwiftUI patterns, and generating test scaffolding. Every tool call is visible in the UI, making the agent's reasoning transparent.

---

## Why MCP?

Before MCP, every AI tool integration was custom-built and incompatible with everything else. MCP is the USB standard for AI tools: a single open protocol that any model (Claude, GPT, Gemini) can use to call any tool that speaks MCP.

SwiftBridge implements an MCP server in Swift — meaning the tools it exposes can also be consumed by Claude Desktop, Cursor, or any other MCP-compatible client.

---

## Architecture

```
┌─────────────────────────────────────┐
│         SwiftUI macOS App           │
│   Chat Interface + Tool Trace Panel │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│            Agent Layer              │
│   Claude API · Tool Use · Streaming │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│            MCP Server               │
│   Protocol · Tool Registry          │
└──────┬───────┬──────────┬───────────┘
       │       │          │          
┌──────▼──┐ ┌──▼──────┐ ┌─▼────────┐ ┌──────────────┐
│ analyze │ │ search  │ │ validate │ │   generate   │
│ _swift  │ │ _apple  │ │ _swiftui │ │    _tests    │
│ _file   │ │ _docs   │ │          │ │              │
└─────────┘ └─────────┘ └──────────┘ └──────────────┘
```

---

## MCP Tools

| Tool | Description |
|------|-------------|
| `analyze_swift_file` | Parses a Swift source file and returns its structure: imports, types, functions, and TODOs |
| `search_apple_docs` | Searches Apple Developer Documentation for Swift APIs and frameworks |
| `validate_swiftui_patterns` | Detects common SwiftUI anti-patterns and suggests improvements |
| `generate_swift_tests` | Generates XCTest unit test templates based on a file's public interface |

---

## Tech Stack

- **Swift** — primary language
- **SwiftUI** — native macOS UI
- **Model Context Protocol** — tool integration standard
- **Claude API** — AI agent engine (Anthropic)
- **Swift Package Manager** — dependency management
- **URLSession** — networking layer

---

## Features

- **Native macOS UI** built with SwiftUI, following Apple's Human Interface Guidelines
- **Transparent agent reasoning** — every tool call the agent makes is visible in the Tool Trace Panel
- **Real MCP server implementation** in Swift — tools are also consumable by external MCP clients
- **Streaming responses** — agent replies stream in real time (coming with Claude API integration)
- **Extensible tool registry** — new tools can be added by conforming to the `MCPTool` protocol

---

## Getting Started

### Requirements

- macOS 14.0+
- Xcode 16+
- Anthropic API key (for agent functionality)

### Setup

```bash
git clone https://github.com/CesarAFC/swiftbridge-mcp.git
cd swiftbridge-mcp
open SwiftBridgeMCP.xcodeproj
```

Add your Anthropic API key in `Agent/AgentService.swift`:

```swift
private let apiKey = "your-api-key-here"
```

Build and run with **⌘R**.

---

## Roadmap

- [x] MCP server with 4 Swift developer tools
- [x] Native macOS SwiftUI interface with Tool Trace Panel
- [x] Tool protocol and registry architecture
- [ ] Claude API integration with streaming and multi-step tool use
- [ ] Full agentic loop — agent chains multiple tools autonomously
- [ ] Swift Package Manager support — use SwiftBridge tools in any MCP client
- [ ] ACP (Agent Communication Protocol) exploration
- [ ] Xcode Extension integration

---

## Background

This project was built to explore the intersection of agentic coding, MCP protocol implementation, and Apple's developer ecosystem — the same space that Apple's Developer Intelligence team is actively working in.

The goal was to go beyond using AI tools to actually implementing the protocol layer that makes tool-augmented AI possible, and to do it natively on Apple's platforms.

---

## Author

**César Fontalvo** — Frontend-Leaning Full Stack Engineer  
[LinkedIn](https://linkedin.com/in/cesar-fontalvo-conrado) · [GitHub](https://github.com/CesarAFC)
