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
    
    let allSkills = [
        "Programming", "Data Analysis", "Design", "Marketing", "Sales",
        "Writing", "Public Speaking", "Project Management", "Finance", "Leadership",
        "Social Media", "Video Production", "Graphic Design", "SEO", "E-commerce"
    ]
    
    let allPersonality = [
        "Creative", "Analytical", "Organized", "Risk-Taker", "Networker",
        "Detail-Oriented", "Visionary", "Collaborative", "Independent", "Problem-Solver"
    ]
    
    let allInterests = [
        "Technology", "Business", "Fitness", "Education", "Entertainment",
        "Fashion", "Food", "Travel", "Real Estate", "Consulting",
        "Coaching", "Content Creation", "E-Learning", "Sustainability", "Art"
    ]
    
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
        case .skills:
            currentStep = .personality
        case .personality:
            currentStep = .interests
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
    
    private func generateIdeas() {
        currentStep = .loading
        let skills = Array(selectedSkills)
        let personality = Array(selectedPersonality)
        let interests = Array(selectedInterests)
        
        GoogleAIService.shared.generateBusinessIdeas(
            skills: skills,
            personality: personality,
            interests: interests
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.currentStep = .results
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print("Error generating ideas: \(error)")
                }
            }
        }
    }
}
