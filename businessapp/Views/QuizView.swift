import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.15, blue: 0.35),
                    Color(red: 0.1, green: 0.2, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                ProgressView(value: Double(stepProgress()), total: 5.0)
                    .tint(Color(red: 1, green: 0.6, blue: 0.2))
                    .padding(20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        switch viewModel.currentStep {
                        case .welcome:
                            WelcomeStepView()
                        case .skills:
                            SkillsStepView(viewModel: viewModel)
                        case .personality:
                            PersonalityStepView(viewModel: viewModel)
                        case .interests:
                            InterestsStepView(viewModel: viewModel)
                        case .personalInfo:
                            PersonalInfoStepView(firstName: $firstName, lastName: $lastName)
                        case .loading:
                            LoadingStepView()
                        case .results:
                            ResultsStepView(viewModel: viewModel)
                        }
                    }
                    .padding(20)
                }
                
                HStack(spacing: 12) {
                    if viewModel.currentStep != .welcome && viewModel.currentStep != .results {
                        Button(action: { viewModel.previousStep() }) {
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .foregroundColor(.white)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                    
                    if viewModel.currentStep != .results && viewModel.currentStep != .loading {
                        Button(action: { viewModel.nextStep() }) {
                            Text("Next")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1, green: 0.6, blue: 0.2),
                                            Color(red: 1, green: 0.4, blue: 0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
    
    func stepProgress() -> Int {
        switch viewModel.currentStep {
        case .welcome: return 1
        case .skills: return 2
        case .personality: return 3
        case .interests: return 4
        case .personalInfo: return 5
        default: return 5
        }
    }
}

struct WelcomeStepView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Let's Discover Your Perfect Business!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("Answer a few quick questions and our AI will generate personalized business ideas tailored to your unique skills, personality, and interests.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(2)
            
            VStack(spacing: 12) {
                InfoBadge("⏱️ Takes about 5 minutes")
                InfoBadge("🤖 Powered by advanced AI")
                InfoBadge("🎯 Completely personalized")
            }
        }
    }
}

struct SkillsStepView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What are your key skills?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Select all that apply")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            VStack(spacing: 12) {
                ForEach(viewModel.allSkills, id: \.self) { skill in
                    ToggleChip(
                        label: skill,
                        isSelected: viewModel.selectedSkills.contains(skill),
                        action: { viewModel.toggleSkill(skill) }
                    )
                }
            }
        }
    }
}

struct PersonalityStepView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Describe your personality")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Choose traits that define you")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            VStack(spacing: 12) {
                ForEach(viewModel.allPersonality, id: \.self) { trait in
                    ToggleChip(
                        label: trait,
                        isSelected: viewModel.selectedPersonality.contains(trait),
                        action: { viewModel.togglePersonality(trait) }
                    )
                }
            }
        }
    }
}

struct InterestsStepView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What interests you?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Select your areas of interest")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            VStack(spacing: 12) {
                ForEach(viewModel.allInterests, id: \.self) { interest in
                    ToggleChip(
                        label: interest,
                        isSelected: viewModel.selectedInterests.contains(interest),
                        action: { viewModel.toggleInterest(interest) }
                    )
                }
            }
        }
    }
}

struct PersonalInfoStepView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tell us about yourself")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                TextField("First Name", text: $firstName)
                    .padding(14)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                
                TextField("Last Name", text: $lastName)
                    .padding(14)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
        }
    }
}

struct LoadingStepView: View {
    var body: some View {
        VStack(spacing: 24) {
            ProgressView()
                .scaleEffect(2)
                .tint(Color(red: 1, green: 0.6, blue: 0.2))
            
            Text("Generating Your Ideas...")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Our AI is analyzing your profile and creating personalized business opportunities")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

struct ResultsStepView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Business Ideas")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Based on your profile, here are personalized ideas:")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            VStack(spacing: 12) {
                ForEach(viewModel.businessIdeas.prefix(3)) { idea in
                    IdeaCardCompact(idea: idea)
                }
            }
        }
    }
}

struct ToggleChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18))
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
            }
            .padding(14)
            .background(isSelected ? Color(red: 1, green: 0.6, blue: 0.2).opacity(0.8) : Color.white.opacity(0.1))
            .cornerRadius(12)
            .foregroundColor(.white)
        }
    }
}

struct InfoBadge: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .foregroundColor(.white)
    }
}

struct IdeaCardCompact: View {
    let idea: BusinessIdea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(idea.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(idea.description)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
            
            HStack(spacing: 8) {
                Badge(idea.category, color: .yellow)
                Badge(idea.difficulty, color: .orange)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct Badge: View {
    let text: String
    let color: Color
    
    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.3))
            .cornerRadius(6)
            .foregroundColor(color)
    }
}

#Preview {
    QuizView()
}
