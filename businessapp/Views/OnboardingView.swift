//
//  OnboardingView.swift
//  BlueprintTest
//
//  Created by Євген Жадан on 06.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var index = 0  // Index of presented view
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    // Skip button at top
                    HStack {
                        Spacer()
                        Button(action: {
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Skip")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.gray)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                    
                    // Speech bubble
                    ZStack {
                        SpeachBubble(cornerRadius: 20, isBottom: true, pointLocation: 50)
                            .fill(.green)
                        
                        Text(Texts.onboardingText[index])
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .frame(width: index == 0 ? 200 : 350, height: 100)
                    
                    // Duo character image
                    Image(index % 2 != 0 ? Images.onboardintImage1 : Images.onboardintImage2)
                        .scaledToFit()
                    
                    // Action buttons
                    if(index == 1) {
                        NavigationLink(destination: OnboardingQuestionaireView()) {
                            Text("Continue")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100))
                                .background(.green)
                                .cornerRadius(10)
                                .padding(.top, 150)
                        }
                    } else if index >= Texts.onboardingText.count - 1 {
                        // Last screen - complete onboarding
                        Button(action: {
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Get Started")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100))
                                .background(.green)
                                .cornerRadius(10)
                                .padding(.top, 150)
                        }
                    } else {
                        Button(action: {
                            index = index + 1
                        }) {
                            Text("Continue")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100))
                                .background(.green)
                                .cornerRadius(10)
                                .padding(.top, 150)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingView()
}

struct SpeachBubble: Shape {
    let cornerRadius: CGFloat
    let isBottom: Bool
    let pointLocation: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        
        // Top left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -180), clockwise: true)
        
        if(!isBottom) {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY - 10))
            
            path.addLine(to: CGPoint(x: rect.minX - 10, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + 10))
        }
        
        // Left side of bubble
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
        
        // Bottom left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
        
        if(isBottom) {
            path.addLine(to: CGPoint(x: pointLocation - 10, y: rect.maxY))
            
            path.addLine(to: CGPoint(x: pointLocation, y: rect.maxY + 10))
            
            path.addLine(to: CGPoint(x: pointLocation + 10, y: rect.maxY))
        }
        
        // Bottom right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 0), clockwise: true)
        
        // Right side of bubble
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
        
        // Top right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: -90), clockwise: true)
        
        return path
    }
}
