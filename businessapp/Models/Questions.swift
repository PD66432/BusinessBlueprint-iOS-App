//
//  Questions.swift
//  BlueprintTest
//
//  Created by Євген Жадан on 06.11.2025.
//

import Foundation

struct Question: Identifiable {
    let id = UUID().uuidString
    let query: String
    let answerImage: [String]
    let answerText: [String]
    let answerSubText: [String]
}

struct StaticQuestions {
    static let questions: [Question] = [
        Question(
            query: "What's your main goal?",
            answerImage: ["graph1", "graph2", "graph3", "graph4"],
            answerText: ["Learn a new skill", "Build a business", "Improve existing", "Other"],
            answerSubText: ["Acquire knowledge", "Start entrepreneurship", "Enhance skills", "Custom goal"]
        ),
        Question(
            query: "How much time can you dedicate?",
            answerImage: [],
            answerText: ["Less than 30 min", "30-60 min", "1-2 hours", "2+ hours"],
            answerSubText: ["Minimal time", "Moderate time", "Significant time", "Full commitment"]
        ),
        Question(
            query: "What's your experience level?",
            answerImage: [],
            answerText: ["Beginner", "Intermediate", "Advanced", "Expert"],
            answerSubText: ["Just starting", "Some background", "Very experienced", "Industry expert"]
        ),
        Question(
            query: "Preferred learning style?",
            answerImage: [],
            answerText: ["Visual", "Interactive", "Reading", "Hands-on"],
            answerSubText: ["Videos/images", "Quizzes/apps", "Articles/docs", "Practice"]
        ),
        Question(
            query: "What motivates you most?",
            answerImage: [],
            answerText: ["Success", "Growth", "Community", "Rewards"],
            answerSubText: ["Achievement", "Progress", "Support", "Incentives"]
        ),
        Question(
            query: "How often do you want reminders?",
            answerImage: [],
            answerText: ["Daily", "Few times/week", "Weekly", "Rarely"],
            answerSubText: ["Every day", "3-4 times", "Once/week", "As needed"]
        ),
        Question(
            query: "Ready to begin?",
            answerImage: [],
            answerText: ["Yes, let's go!", "Need more info", "Maybe later", ""],
            answerSubText: ["Start now", "Tell me more", "Not ready", ""]
        )
    ]
}

