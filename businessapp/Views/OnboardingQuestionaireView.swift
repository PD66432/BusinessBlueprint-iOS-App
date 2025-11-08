//
//  OnboardingQuestionaireView.swift
//  BlueprintTest
//
//  Created by Євген Жадан on 06.11.2025.
//

import SwiftUI

struct OnboardingQuestionaireView: View {
    @State private var progress = 0.1  // Progress bar value
    @State private var index = 0  // Index of presented view
    @State private var selectedEntry = Array(1...StaticQuestions.questions[0].answerImage.count).map { _ in false }
    @StateObject var viewModel = OnboardingViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {  // Dismiss button
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    
                    ZStack(alignment: .leading) {  // Progress bar
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.3))
                            .frame(width: 300, height: 20)
                        
                        Rectangle()
                            .foregroundStyle(.green)
                            .frame(width: CGFloat(progress) * 300, height: 20)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .clipShape(.rect(cornerRadius: 10))
                }
                
                HStack {
                    Image("duoReading")
                        .resizable()
                        .scaledToFit()
                    
                    ZStack {
                        SpeachBubble(cornerRadius: 20, isBottom: false, pointLocation: 20)
                            .fill(.green)
                        
                        Text(StaticQuestions.questions[index].query)  // Question
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .frame(width: 200, height: 100)
                    .padding()
                }
                
                if index == 0 {
                    Text("For English speakers")
                        .font(.system(size: 25))
                        .bold()
                        .foregroundStyle(.black)
                        .padding()
                }
                
                ScrollView {  // Answer cards
                    LazyVStack {
                        ForEach(0..<viewModel.question.answerText.count, id: \.self) { i in
                            SelectionCardView(question: $viewModel.question, selectedEntry: $selectedEntry, queryIndex: index, selectedIndex: i)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {  // Continue Button
                    if(index < 3) {
                        index = index + 1
                        viewModel.getQuestionAtIndex(index: index)
                        
                        if(StaticQuestions.questions[index].answerText.count > 0) {
                            selectedEntry = []
                            selectedEntry = Array(1...StaticQuestions.questions[index].answerText.count).map { _ in false }
                        }
                        
                        progress = CGFloat(index + 1) / 7.0
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100))
                        .background(isEnableContinueButton() ? .green : .gray)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .padding(.leading, 50)
                .disabled(!isEnableContinueButton())
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func isEnableContinueButton() -> Bool {
        for i in 0..<selectedEntry.count {
            if(selectedEntry[i]) {
                return true
            }
        }
        
        return false
    }
}

#Preview {
    OnboardingQuestionaireView()
}
