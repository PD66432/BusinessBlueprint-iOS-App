import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var dailyGoals: [DailyGoal] = []
    @Published var milestones: [Milestone] = []
    @Published var selectedBusinessIdea: BusinessIdea?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var completionPercentage: Int = 0
    
    private var userId: String?
    
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    func fetchDashboardData(businessIdeaId: String) {
        isLoading = true
        
        let group = DispatchGroup()
        
        group.enter()
        FirebaseService.shared.fetchDailyGoals(userId: userId ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let goals):
                    self?.dailyGoals = goals
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        group.enter()
        FirebaseService.shared.fetchMilestones(businessIdeaId: businessIdeaId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let milestones):
                    self?.milestones = milestones
                    self?.calculateCompletion()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func addDailyGoal(_ goal: DailyGoal) {
        FirebaseService.shared.saveDailyGoal(goal) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.dailyGoals.append(goal)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func addMilestone(_ milestone: Milestone) {
        FirebaseService.shared.saveMilestone(milestone) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.milestones.append(milestone)
                    self?.calculateCompletion()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func toggleGoalCompletion(_ goalId: String) {
        if let index = dailyGoals.firstIndex(where: { $0.id == goalId }) {
            var goal = dailyGoals[index]
            // In a real app, update Firebase here
            dailyGoals[index] = DailyGoal(
                id: goal.id,
                businessIdeaId: goal.businessIdeaId,
                title: goal.title,
                description: goal.description,
                dueDate: goal.dueDate,
                completed: !goal.completed,
                priority: goal.priority,
                createdAt: goal.createdAt,
                userId: goal.userId
            )
        }
    }
    
    func toggleMilestoneCompletion(_ milestoneId: String) {
        if let index = milestones.firstIndex(where: { $0.id == milestoneId }) {
            var milestone = milestones[index]
            milestones[index] = Milestone(
                id: milestone.id,
                businessIdeaId: milestone.businessIdeaId,
                title: milestone.title,
                description: milestone.description,
                dueDate: milestone.dueDate,
                completed: !milestone.completed,
                order: milestone.order,
                createdAt: milestone.createdAt,
                userId: milestone.userId
            )
            calculateCompletion()
        }
    }
    
    private func calculateCompletion() {
        let completedMilestones = milestones.filter { $0.completed }.count
        let total = milestones.count
        completionPercentage = total > 0 ? (completedMilestones * 100) / total : 0
    }
    
    var upcomingGoals: [DailyGoal] {
        dailyGoals.filter { !$0.completed && $0.dueDate > Date() }
            .sorted { $0.dueDate < $1.dueDate }
            .prefix(5)
            .map { $0 }
    }
    
    var completedGoalsCount: Int {
        dailyGoals.filter { $0.completed }.count
    }
}
