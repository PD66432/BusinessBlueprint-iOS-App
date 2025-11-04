import SwiftUI

struct LaunchView: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.15, blue: 0.35),
                    Color(red: 0.1, green: 0.2, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 16) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)
                    
                    Text("Business Blueprint")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Discover your perfect business idea powered by AI")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                    .frame(height: 100)
                
                VStack(spacing: 12) {
                    Button(action: { showSignUp = true }) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1, green: 0.6, blue: 0.2),
                                        Color(red: 1, green: 0.4, blue: 0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    Button(action: {}) {
                        Text("Sign In")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundColor(.white)
                            .border(Color.white.opacity(0.3), width: 2)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 40)
                
                VStack(spacing: 8) {
                    Text("Why Business Blueprint?")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        FeatureTag("AI Powered", icon: "sparkles")
                        FeatureTag("Personalized", icon: "person.fill")
                        FeatureTag("Easy", icon: "checkmark.circle.fill")
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSignUp) {
            AuthView(viewModel: authVM)
        }
    }
}

struct FeatureTag: View {
    let text: String
    let icon: String
    
    init(_ text: String, icon: String) {
        self.text = text
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.15))
        .cornerRadius(8)
    }
}

#Preview {
    LaunchView()
}
