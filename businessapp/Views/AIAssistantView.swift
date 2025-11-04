import SwiftUI
import Combine

struct AIAssistantView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AIAssistantViewModel
    let businessIdea: BusinessIdea
    
    init(businessIdea: BusinessIdea) {
        self.businessIdea = businessIdea
        _viewModel = StateObject(wrappedValue: AIAssistantViewModel(businessIdea: businessIdea))
    }
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.18),
                    Color(red: 0.09, green: 0.13, blue: 0.24)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Image(systemName: "sparkles")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(alignment: .leading) {
                            Text("AI Assistant")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text("Powered by Google Gemini")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    // Business Idea Context
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Business")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.orange)
                            Text(businessIdea.title)
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // AI Analysis Section
                    if let analysis = viewModel.businessAnalysis {
                        AIAnalysisCard(analysis: analysis)
                    }
                    
                    // Daily Goals Section
                    if !viewModel.dailyGoals.isEmpty {
                        DailyGoalsCard(goals: viewModel.dailyGoals)
                    }
                    
                    // Personalized Advice Section
                    if !viewModel.personalizedAdvice.isEmpty {
                        PersonalizedAdviceCard(advice: viewModel.personalizedAdvice)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        AIActionButton(
                            title: "Analyze Business Idea",
                            icon: "chart.bar.fill",
                            isLoading: viewModel.isAnalyzing
                        ) {
                            viewModel.analyzeBusinessIdea()
                        }
                        
                        AIActionButton(
                            title: "Generate Daily Goals",
                            icon: "target",
                            isLoading: viewModel.isGeneratingGoals
                        ) {
                            viewModel.generateDailyGoals()
                        }
                        
                        AIActionButton(
                            title: "Get Personalized Advice",
                            icon: "message.fill",
                            isLoading: viewModel.isGettingAdvice
                        ) {
                            viewModel.getPersonalizedAdvice()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

// MARK: - AI Analysis Card

struct AIAnalysisCard: View {
    let analysis: AIBusinessAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Business Analysis")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                ViabilityBadge(score: analysis.viabilityScore)
            }
            
            SectionList(title: "Strengths", items: analysis.strengths, color: .green)
            SectionList(title: "Opportunities", items: analysis.opportunities, color: .blue)
            SectionList(title: "Weaknesses", items: analysis.weaknesses, color: .orange)
            SectionList(title: "Threats", items: analysis.threats, color: .red)
            
            if !analysis.recommendations.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🎯 Recommendations")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                    
                    ForEach(analysis.recommendations, id: \.self) { rec in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text(rec)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct SectionList: View {
    let title: String
    let items: [String]
    let color: Color
    
    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(color)
                
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Circle()
                            .fill(color)
                            .frame(width: 4, height: 4)
                            .padding(.top, 6)
                        Text(item)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
    }
}

struct ViabilityBadge: View {
    let score: Int
    
    var color: Color {
        if score >= 80 { return .green }
        if score >= 60 { return .orange }
        return .red
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(score)%")
                .font(.caption.bold())
            Text("Viable")
                .font(.caption)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.3))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: 1)
        )
    }
}

// MARK: - Daily Goals Card

struct DailyGoalsCard: View {
    let goals: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎯 AI-Generated Daily Goals")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(Array(goals.enumerated()), id: \.offset) { index, goal in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    }
                    
                    Text(goal)
                        .font(.body)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Personalized Advice Card

struct PersonalizedAdviceCard: View {
    let advice: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.orange)
                Text("Personalized Advice")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Text(advice)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.2), Color.pink.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - AI Action Button

struct AIActionButton: View {
    let title: String
    let icon: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(isLoading ? "Thinking..." : title)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.orange, .pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}

// MARK: - AI Assistant ViewModel

class AIAssistantViewModel: ObservableObject {
    @Published var businessAnalysis: AIBusinessAnalysis?
    @Published var dailyGoals: [String] = []
    @Published var personalizedAdvice: String = ""
    @Published var isAnalyzing = false
    @Published var isGeneratingGoals = false
    @Published var isGettingAdvice = false
    
    let businessIdea: BusinessIdea
    
    init(businessIdea: BusinessIdea) {
        self.businessIdea = businessIdea
    }
    
    func analyzeBusinessIdea() {
        isAnalyzing = true
        
        let userProfile: [String: Any] = [
            "category": businessIdea.category,
            "difficulty": businessIdea.difficulty
        ]
        
        GoogleAIService.shared.analyzeBusinessIdea(
            idea: businessIdea,
            userProfile: userProfile
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isAnalyzing = false
                switch result {
                case .success(let analysis):
                    self?.businessAnalysis = analysis
                case .failure(let error):
                    print("Error analyzing idea: \(error)")
                }
            }
        }
    }
    
    func generateDailyGoals() {
        isGeneratingGoals = true
        
        GoogleAIService.shared.generateDailyGoals(
            businessIdea: businessIdea,
            currentProgress: businessAnalysis?.viabilityScore ?? 0
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isGeneratingGoals = false
                switch result {
                case .success(let goals):
                    self?.dailyGoals = goals
                case .failure(let error):
                    print("Error generating goals: \(error)")
                }
            }
        }
    }
    
    func getPersonalizedAdvice() {
        isGettingAdvice = true
        
        let context = "Working on: \(businessIdea.title). \(businessIdea.description)"
        
        GoogleAIService.shared.getPersonalizedAdvice(
            context: context,
            userGoals: dailyGoals
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isGettingAdvice = false
                switch result {
                case .success(let advice):
                    self?.personalizedAdvice = advice
                case .failure(let error):
                    print("Error getting advice: \(error)")
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AIAssistantView(businessIdea: BusinessIdea(
        id: UUID().uuidString,
        title: "AI-Powered Consulting",
        description: "Help businesses leverage AI technology",
        category: "Technology",
        difficulty: "Medium",
        estimatedRevenue: "$100K-$250K/year",
        timeToLaunch: "3-6 months",
        requiredSkills: ["AI/ML", "Business", "Communication"],
        startupCost: "$5K-$15K",
        profitMargin: "60-80%",
        marketDemand: "High",
        competition: "Medium",
        createdAt: Date(),
        userId: "",
        personalizedNotes: "Perfect for tech-savvy entrepreneurs"
    ))
}
