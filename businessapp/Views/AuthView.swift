import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State var isSignUp: Bool = true
    
    var body: some View {
        NavigationStack {
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
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(20)
                    
                    VStack(spacing: 24) {
                        Text(isSignUp ? "Create Account" : "Welcome Back")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 16) {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .padding(14)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                            
                            SecureField("Password", text: $password)
                                .textContentType(.password)
                                .padding(14)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            if isSignUp {
                                viewModel.signUp(email: email, password: password)
                            } else {
                                viewModel.signIn(email: email, password: password)
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
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
                        .cornerRadius(12)
                        .disabled(email.isEmpty || password.isEmpty || viewModel.isLoading)
                        .onChange(of: viewModel.isLoggedIn) { _, newValue in
                            if newValue {
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                            .foregroundColor(.white.opacity(0.7))
                        Button(action: { isSignUp.toggle() }) {
                            Text(isSignUp ? "Sign In" : "Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(.yellow)
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}
