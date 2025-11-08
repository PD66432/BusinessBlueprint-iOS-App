//
//  ProgressBarView.swift
//  BlueprintTest
//
//  Created by Євген Жадан on 07.11.2025.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double // Value between 0.0 and 1.0
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.2))
                .frame(width: 200, height: 8)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("orangeAccent"),
                            Color("yellowSecondary")
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: CGFloat(min(max(progress, 0), 1)) * 200, height: 8)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: progress)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBarView(progress: 0.0)
        ProgressBarView(progress: 0.25)
        ProgressBarView(progress: 0.5)
        ProgressBarView(progress: 0.75)
        ProgressBarView(progress: 1.0)
    }
    .padding()
    .background(Color("deepBlue"))
}

