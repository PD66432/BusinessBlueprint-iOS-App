//
//  AnalyticsManager.swift
//  VentureVoyage
//
//  Centralized analytics tracking manager
//  Provides type-safe event tracking with automatic parameter handling
//

import Foundation
import FirebaseAnalytics

/// Centralized manager for analytics events throughout the app
@MainActor
final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {
        print("📊 AnalyticsManager: Initialized")
    }

    // MARK: - Authentication Events

    /// Tracks user sign up event
    func trackSignUp(method: AuthMethod) {
        let eventName = method.analyticsEvent
        let parameters = ["method": method.rawValue]

        Analytics.logEvent(eventName, parameters: parameters)
        print("📊 Analytics: \(eventName) - method: \(method.rawValue)")
    }

    /// Tracks user login event
    func trackLogin(method: AuthMethod) {
        let eventName = method.analyticsEvent
        let parameters = ["method": method.rawValue]

        Analytics.logEvent(eventName, parameters: parameters)
        print("📊 Analytics: \(eventName) - method: \(method.rawValue)")
    }

    /// Tracks user logout
    func trackLogout() {
        Analytics.logEvent("logout", parameters: nil)
        print("📊 Analytics: logout")
    }

    // MARK: - Business Idea Events

    /// Tracks business idea generation
    func trackIdeaGeneration(count: Int, skills: [String]) {
        let parameters: [String: Any] = [
            "idea_count": count,
            "skill_count": skills.count,
            "skills": skills.joined(separator: ",")
        ]

        Analytics.logEvent(AnalyticsEvents.ideaGenerated, parameters: parameters)
        print("📊 Analytics: \(AnalyticsEvents.ideaGenerated) - count: \(count)")
    }

    /// Tracks business idea selection
    func trackIdeaSelection(idea: BusinessIdea) {
        let parameters: [String: Any] = [
            "idea_id": idea.id,
            "idea_category": idea.category,
            "idea_difficulty": idea.difficulty
        ]

        Analytics.logEvent("idea_selected", parameters: parameters)
        print("📊 Analytics: idea_selected - category: \(idea.category)")
    }

    /// Tracks business idea saved
    func trackIdeaSaved(idea: BusinessIdea) {
        let parameters: [String: Any] = [
            "idea_id": idea.id,
            "idea_category": idea.category
        ]

        Analytics.logEvent("idea_saved", parameters: parameters)
        print("📊 Analytics: idea_saved")
    }

    // MARK: - Goal & Milestone Events

    /// Tracks goal creation
    func trackGoalCreated(goalType: String) {
        let parameters = ["goal_type": goalType]

        Analytics.logEvent("goal_created", parameters: parameters)
        print("📊 Analytics: goal_created - type: \(goalType)")
    }

    /// Tracks goal completion
    func trackGoalCompleted(goalId: String, daysTaken: Int? = nil) {
        var parameters: [String: Any] = ["goal_id": goalId]

        if let days = daysTaken {
            parameters["days_taken"] = days
        }

        Analytics.logEvent(AnalyticsEvents.goalCompleted, parameters: parameters)
        print("📊 Analytics: \(AnalyticsEvents.goalCompleted)")
    }

    /// Tracks milestone reached
    func trackMilestoneReached(milestoneId: String, progress: Int) {
        let parameters: [String: Any] = [
            "milestone_id": milestoneId,
            "progress_percentage": progress
        ]

        Analytics.logEvent(AnalyticsEvents.milestoneReached, parameters: parameters)
        print("📊 Analytics: \(AnalyticsEvents.milestoneReached) - progress: \(progress)%")
    }

    // MARK: - AI Interaction Events

    /// Tracks AI chat interaction
    func trackAIChatMessage(messageLength: Int, responseTime: TimeInterval? = nil) {
        var parameters: [String: Any] = ["message_length": messageLength]

        if let responseTime = responseTime {
            parameters["response_time_ms"] = Int(responseTime * 1000)
        }

        Analytics.logEvent("ai_chat_message", parameters: parameters)
        print("📊 Analytics: ai_chat_message")
    }

    /// Tracks AI suggestion requested
    func trackAISuggestionRequested(context: String) {
        let parameters = ["context": context]

        Analytics.logEvent("ai_suggestion_requested", parameters: parameters)
        print("📊 Analytics: ai_suggestion_requested - context: \(context)")
    }

    /// Tracks AI suggestion accepted
    func trackAISuggestionAccepted(suggestionType: String) {
        let parameters = ["suggestion_type": suggestionType]

        Analytics.logEvent("ai_suggestion_accepted", parameters: parameters)
        print("📊 Analytics: ai_suggestion_accepted")
    }

    // MARK: - User Journey Events

    /// Tracks onboarding completion
    func trackOnboardingCompleted(timeSpent: TimeInterval) {
        let parameters = ["time_spent_seconds": Int(timeSpent)]

        Analytics.logEvent("onboarding_completed", parameters: parameters)
        print("📊 Analytics: onboarding_completed - time: \(Int(timeSpent))s")
    }

    /// Tracks feature discovery
    func trackFeatureDiscovered(featureName: String) {
        let parameters = ["feature_name": featureName]

        Analytics.logEvent("feature_discovered", parameters: parameters)
        print("📊 Analytics: feature_discovered - \(featureName)")
    }

    /// Tracks screen view
    func trackScreenView(screenName: String, screenClass: String? = nil) {
        var parameters: [String: Any] = [
            Analytics.ParameterScreenName: screenName
        ]

        if let screenClass = screenClass {
            parameters[Analytics.ParameterScreenClass] = screenClass
        }

        Analytics.logEvent(Analytics.EventScreenView, parameters: parameters)
        print("📊 Analytics: screen_view - \(screenName)")
    }

    // MARK: - Error Events

    /// Tracks errors for debugging
    func trackError(error: Error, context: String) {
        let parameters: [String: Any] = [
            "error_description": error.localizedDescription,
            "error_context": context,
            "error_domain": (error as NSError).domain,
            "error_code": (error as NSError).code
        ]

        Analytics.logEvent("error_occurred", parameters: parameters)
        print("📊 Analytics: error_occurred - \(context): \(error.localizedDescription)")
    }

    /// Tracks API errors
    func trackAPIError(endpoint: String, statusCode: Int, errorMessage: String) {
        let parameters: [String: Any] = [
            "endpoint": endpoint,
            "status_code": statusCode,
            "error_message": errorMessage
        ]

        Analytics.logEvent("api_error", parameters: parameters)
        print("📊 Analytics: api_error - \(endpoint): \(statusCode)")
    }

    // MARK: - Engagement Events

    /// Tracks daily active user
    func trackDailyActive() {
        Analytics.logEvent("daily_active", parameters: nil)
        print("📊 Analytics: daily_active")
    }

    /// Tracks session start
    func trackSessionStart() {
        Analytics.logEvent("session_start", parameters: ["timestamp": Date().timeIntervalSince1970])
        print("📊 Analytics: session_start")
    }

    /// Tracks session end
    func trackSessionEnd(duration: TimeInterval) {
        let parameters = ["session_duration_seconds": Int(duration)]

        Analytics.logEvent("session_end", parameters: parameters)
        print("📊 Analytics: session_end - duration: \(Int(duration))s")
    }

    // MARK: - User Properties

    /// Sets user properties for segmentation
    func setUserProperty(name: String, value: String) {
        Analytics.setUserProperty(value, forName: name)
        print("📊 Analytics: Set user property - \(name): \(value)")
    }

    /// Sets user ID
    func setUserId(_ userId: String) {
        Analytics.setUserID(userId)
        print("📊 Analytics: Set user ID - \(userId)")
    }
}

// MARK: - Supporting Types

/// Authentication methods for analytics
enum AuthMethod: String {
    case email = "email"
    case google = "google"
    case apple = "apple"
    case anonymous = "anonymous"

    var analyticsEvent: String {
        switch self {
        case .email: return AnalyticsEvents.loginEmail
        case .google: return AnalyticsEvents.loginGoogle
        case .apple: return AnalyticsEvents.loginApple
        case .anonymous: return AnalyticsEvents.loginAnonymous
        }
    }
}

// MARK: - Analytics Extensions

extension AnalyticsManager {
    /// Tracks custom event with parameters
    func trackCustomEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)

        if let params = parameters {
            print("📊 Analytics: \(name) - \(params)")
        } else {
            print("📊 Analytics: \(name)")
        }
    }
}
