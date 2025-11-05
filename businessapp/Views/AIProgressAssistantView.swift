import SwiftUI

struct AIProgressAssistantView: View {
    @ObservedObject var viewModel: IslandTimelineViewModel
    @State private var userQuestion = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.2, green: 0.1, blue: 0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Chat Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 16) {
                                // Welcome message
                                if messages.isEmpty {
                                    WelcomeMessageView()
                                        .padding()
                                }
                                
                                // Messages
                                ForEach(messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }
                                
                                // Loading indicator
                                if isLoading {
                                    HStack {
                                        ProgressView()
                                            .tint(.white)
                                        Text("Thinking...")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .padding()
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { _ in
                            if let lastMessage = messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Quick Actions
                    QuickActionsView(onAction: { action in
                        sendMessage(action)
                    })
                    .padding(.horizontal)
                    
                    // Input Area
                    MessageInputView(
                        text: $userQuestion,
                        isLoading: isLoading,
                        onSend: {
                            sendMessage(userQuestion)
                        }
                    )
                    .padding()
                }
            }
            .navigationTitle("AI Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func sendMessage(_ text: String) {
        guard !text.isEmpty, !isLoading else { return }
        
        // Add user message
        let userMessage = ChatMessage(content: text, isFromUser: true)
        messages.append(userMessage)
        userQuestion = ""
        isLoading = true
        
        // Get AI response
        viewModel.askAIAboutProgress(question: text) { response in
            isLoading = false
            let aiMessage = ChatMessage(content: response, isFromUser: false)
            messages.append(aiMessage)
        }
    }
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp = Date()
}

// MARK: - Welcome Message
struct WelcomeMessageView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Your AI Business Guide")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text("I'm here to help you navigate your journey! Ask me anything about your progress, goals, or next steps.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isFromUser ? .white : .black)
                    .padding(12)
                    .background(
                        message.isFromUser ?
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.white, .white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            if !message.isFromUser { Spacer() }
        }
    }
}

// MARK: - Quick Actions
struct QuickActionsView: View {
    let onAction: (String) -> Void
    
    let quickActions = [
        ("chart.line.uptrend.xyaxis", "Show my progress"),
        ("lightbulb.fill", "Give me a tip"),
        ("flag.fill", "What's next?"),
        ("target", "Set a new goal")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(quickActions, id: \.0) { icon, text in
                    Button {
                        onAction(text)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: icon)
                            Text(text)
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Message Input
struct MessageInputView: View {
    @Binding var text: String
    let isLoading: Bool
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Ask me anything...", text: $text)
                .textFieldStyle(.plain)
                .foregroundColor(.white)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .disabled(isLoading)
            
            Button {
                onSend()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(text.isEmpty ? .gray : .blue)
            }
            .disabled(text.isEmpty || isLoading)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.3))
        )
    }
}

#Preview {
    AIProgressAssistantView(viewModel: IslandTimelineViewModel())
}
