import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @State private var showQuiz = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                QuizView(onComplete: {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    hasCompletedOnboarding = true
                })
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
