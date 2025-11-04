import Foundation
import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentStep: QuizStep = .welcome
    @Published var selectedSkills: Set<String> = []
    @Published var selectedPersonality: Set<String> = []
    @Published var selectedInterests: Set<String> = []
    @Published var userProfile: UserProfile?
    @Published var businessIdeas: [BusinessIdea] = []
    @Published var isLoading = false
    @Published var aiGeneratedOptions: [String] = []
    @Published var isGeneratingOptions = false
    
    // Fallback options if AI fails
    let defaultSkills = [
        "Programming", "Data Analysis", "Design", "Marketing", "Sales",
        "Writing", "Public Speaking", "Project Management", "Finance", "Leadership"
    ]
    
    let defaultPersonality = [
        "Creative", "Analytical", "Organized", "Risk-Taker", "Networker",
        "Detail-Oriented", "Visionary", "Collaborative", "Independent", "Problem-Solver"
    ]
    
    let defaultInterests = [
        "Technology", "Business", "Fitness", "Education", "Entertainment",
        "Fashion", "Food", "Travel", "Real Estate", "Consulting"
    ]
    
    // Dynamic AI-powered options
    var allSkills: [String] {
        return aiGeneratedOptions.isEmpty ? defaultSkills : aiGeneratedOptions
    }
    
    var allPersonality: [String] {
        return aiGeneratedOptions.isEmpty ? defaultPersonality : aiGeneratedOptions
    }
    
    var allInterests: [String] {
        return aiGeneratedOptions.isEmpty ? defaultInterests : aiGeneratedOptions
    }
    
    enum QuizStep {
        case welcome
        case skills
        case personality
        case interests
        case personalInfo
        case loading
        case results
    }
    
    func nextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .skills
            loadAIOptionsForStep(1)
        case .skills:
            currentStep = .personality
            loadAIOptionsForStep(2)
        case .personality:
            currentStep = .interests
            loadAIOptionsForStep(3)
        case .interests:
            currentStep = .personalInfo
        case .personalInfo:
            generateIdeas()
        case .loading, .results:
            break
        }
    }
    
    func previousStep() {
        switch currentStep {
        case .welcome:
            break
        case .skills:
            currentStep = .welcome
        case .personality:
            currentStep = .skills
        case .interests:
            currentStep = .personality
        case .personalInfo:
            currentStep = .interests
        case .loading, .results:
            break
        }
    }
    
    func toggleSkill(_ skill: String) {
        if selectedSkills.contains(skill) {
            selectedSkills.remove(skill)
        } else {
            selectedSkills.insert(skill)
        }
    }
    
    func togglePersonality(_ trait: String) {
        if selectedPersonality.contains(trait) {
            selectedPersonality.remove(trait)
        } else {
            selectedPersonality.insert(trait)
        }
    }
    
    func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
    
    // MARK: - AI-Powered Quiz Generation
    
    private func loadAIOptionsForStep(_ step: Int) {
        isGeneratingOptions = true
        
        var previousAnswers: [String: [String]] = [:]
        if step >= 2 {
            previousAnswers["skills"] = Array(selectedSkills)
        }
        if step >= 3 {
            previousAnswers["personality"] = Array(selectedPersonality)
        }
        
        GoogleAIService.shared.generateQuizQuestions(
            step: step,
            previousAnswers: previousAnswers
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isGeneratingOptions = false
                switch result {
                case .success(let questions):
                    if let firstQuestion = questions.first {
                        self?.aiGeneratedOptions = firstQuestion.options
                    }
                case .failure(let error):
                    print("Error generating quiz options: \(error)")
                    // Fallback to default options
                    self?.aiGeneratedOptions = []
                }
            }
        }
    }
    
    private func generateIdeas() {
        currentStep = .loading
        isLoading = true
        let skills = Array(selectedSkills)
        let personality = Array(selectedPersonality)
        let interests = Array(selectedInterests)
        
        GoogleAIService.shared.generateBusinessIdeas(
            skills: skills,
            personality: personality,
            interests: interests
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.currentStep = .results
                switch result {
                case .success(let ideas):
                    self?.businessIdeas = ideas
                    print("✅ Generated \(ideas.count) AI-powered business ideas")
                case .failure(let error):
                    print("⚠️ Error generating ideas: \(error.localizedDescription)")
                    // AI fallback is handled in GoogleAIService
                    self?.businessIdeas = []
                }
            }
        }
    }
}
