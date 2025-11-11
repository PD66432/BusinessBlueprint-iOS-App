//
//  OnboardingManager.swift
//  businessapp
//
//  Created by Євген Жадан on 07.11.2025.
//

import Foundation
import SwiftUI
import Combine

class OnboardingManager: ObservableObject {
    static let shared = OnboardingManager()
    
    // Onboarding flow:
    // - OnboardingView: User sees screens 0 and 1 (2 screens), then navigates to questionnaire
    // - OnboardingQuestionaireView: questions from StaticQuestions
    // Total steps = 2 onboarding screens + questions = variable total
    
    static let onboardingScreensCount = 2 // Screens shown before questionnaire (index 0 and 1)
    static let questionnaireQuestionsCount = StaticQuestions.questions.count
    static let totalSteps = onboardingScreensCount + questionnaireQuestionsCount
    
    @Published var onboardingViewIndex: Int = 0
    @Published var questionnaireIndex: Int = 0
    @Published var isInQuestionnaire: Bool = false
    
    // Completion state - use UserDefaults directly for persistence
    var isOnboardingCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isOnboardingCompleted")
            objectWillChange.send()
        }
    }
    
    private init() {}
    
    // Calculate unified progress across both views (0.0 to 1.0)
    var totalProgress: Double {
        if isInQuestionnaire {
            // In questionnaire: onboarding screens (2) + current question progress
            let completedSteps = Self.onboardingScreensCount + questionnaireIndex + 1
            return Double(completedSteps) / Double(Self.totalSteps)
        } else {
            // In onboarding view: current screen progress
            return Double(onboardingViewIndex + 1) / Double(Self.totalSteps)
        }
    }
    
    // Get current step number (1-based, for display purposes)
    var currentStep: Int {
        if isInQuestionnaire {
            return Self.onboardingScreensCount + questionnaireIndex + 1
        } else {
            return onboardingViewIndex + 1
        }
    }
    
    // Mark onboarding as completed
    func completeOnboarding() {
        isOnboardingCompleted = true
        // Reset state
        resetToStart()
    }
    
    // Reset onboarding to start (for testing or re-onboarding)
    func resetToStart() {
        onboardingViewIndex = 0
        questionnaireIndex = 0
        isInQuestionnaire = false
    }
    
    // Reset onboarding completion state (for re-onboarding)
    func resetOnboarding() {
        isOnboardingCompleted = false
        resetToStart()
    }
    
    // Navigate to questionnaire (called when user moves from onboarding to questionnaire)
    func startQuestionnaire() {
        isInQuestionnaire = true
        questionnaireIndex = 0
        // Ensure we mark onboarding screens as completed
        if onboardingViewIndex < Self.onboardingScreensCount - 1 {
            onboardingViewIndex = Self.onboardingScreensCount - 1
        }
    }
}