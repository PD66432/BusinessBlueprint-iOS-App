//
//  OnboardingViewModel.swift
//  businessapp
//
//  Created by Євген Жадан on 07.11.2025.
//

import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var question: Question
    var index: Int
    
    init(){
        question = Question(query: "", answerImage: [], answerText: [], answerSubText: [])
        index = 0
        self.getQuestionAtIndex(index: index)
    }
    
    func getQuestionAtIndex(index: Int) {
        if index < StaticQuestions.questions.count {
            question = StaticQuestions.questions[index]
        }
    }
}