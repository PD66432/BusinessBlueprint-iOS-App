import Foundation
import SwiftUI

class BusinessIdeaViewModel: ObservableObject {
    @Published var businessIdeas: [BusinessIdea] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedIdea: BusinessIdea?
    
    private var userId: String?
    
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    func generateIdeas(skills: [String], personality: [String], interests: [String]) {
        isLoading = true
        errorMessage = nil
        
        GoogleAIService.shared.generateBusinessIdeas(
            skills: skills,
            personality: personality,
            interests: interests
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ideas):
                    self?.businessIdeas = ideas
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func saveIdea(_ idea: BusinessIdea) {
        FirebaseService.shared.saveBusinessIdea(idea) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.businessIdeas.firstIndex(where: { $0.id == idea.id }) {
                        self?.businessIdeas[index].saved = true
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchIdeas() {
        guard let userId = userId else { return }
        isLoading = true
        
        FirebaseService.shared.fetchBusinessIdeas(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ideas):
                    self?.businessIdeas = ideas
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getAISuggestions(for idea: BusinessIdea) {
        GoogleAIService.shared.getAISuggestions(businessIdea: idea) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    print("AI Suggestions: \(suggestions)")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateProgress(ideaId: String, progress: Int) {
        FirebaseService.shared.updateBusinessIdeaProgress(ideaId, progress: progress) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.businessIdeas.firstIndex(where: { $0.id == ideaId }) {
                        self?.businessIdeas[index].progress = progress
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
