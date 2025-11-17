//
//  AppConstants.swift
//  Business Blueprint
//
//  Application-wide constants and configurations
//

import Foundation

// MARK: - User Defaults Keys
enum UserDefaultsKeys {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let businessIdeasData = "businessIdeasData"
    static let userProfileData = "userProfileData"
    static let selectedBusinessIdeaID = "selectedBusinessIdeaID"
    static let savedIslands = "saved_islands"
    static let journeyProgress = "journey_progress"
    static let progressNotes = "progress_notes"
    static let appReminders = "app_reminders"
    static let googleAIAPIKey = "GOOGLE_AI_API_KEY"
    static let googleAIModel = "GOOGLE_AI_MODEL"
}

// MARK: - Analytics Event Names
enum AnalyticsEvents {
    static let signUpEmail = "sign_up_email"
    static let loginEmail = "login_email"
    static let loginAnonymous = "login_anonymous"
    static let loginGoogle = "login_google"
    static let loginApple = "login_apple"
    static let ideaGenerated = "idea_generated"
    static let goalCompleted = "goal_completed"
    static let milestoneReached = "milestone_reached"
}

// MARK: - UI Constants
enum UIConstants {
    static let animationDuration: Double = 0.3
    static let longAnimationDuration: Double = 0.6
    static let cornerRadius: CGFloat = 12
    static let largeCornerRadius: CGFloat = 20
    static let defaultPadding: CGFloat = 16
    static let largePadding: CGFloat = 24
}

// MARK: - Legacy Onboarding Text (to be updated)
struct Texts {
    static let onboardingText: [String] = [
        "Hi there! I'm Duo!",
        "Just 7 quick questions before we start your first lesson!",
        "DuoLingoLessons are backed by extensive research ...",
        "... and they are also designed to be fun",
        "Congrats on Completing your first lesson!",
        "Now let's build you a habit of practicing every day."
    ]
}

// MARK: - Legacy Images (to be updated)
struct Images {
    static let gettingStartedImage = "duoWithName"
    static let onboardintImage1 = "duoHappy.svg"
    static let onboardintImage2 = "duoInterested"
}
