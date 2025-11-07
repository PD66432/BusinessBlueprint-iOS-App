import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var businessPlanStore: BusinessPlanStore
    @State private var showBrainDump = false
    @State private var showIdeaGenerator = false
    @State private var selectedIdea: BusinessIdea?
    
    private var firstName: String {
        businessPlanStore.userProfile?.firstName ?? "there"
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    // Hero Section - Simple and Clean
                    VStack(spacing: 16) {
                        Text("Welcome, \(firstName)! 👋")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Ready to discover your perfect business idea?")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 60)
                    .fadeInUp()
                    
                    // Main Actions - Clean Cards
                    VStack(spacing: 20) {
                        // Brain Dump
                        CleanActionCard(
                            title: "Brain Dump",
                            subtitle: "Share your thoughts and ideas",
                            icon: "brain.head.profile",
                            color: AppColors.primary
                        ) {
                            showBrainDump = true
                            HapticManager.shared.trigger(.medium)
                        }
                        .fadeInUp(delay: 0.1)
                        
                        // Generate Ideas
                        CleanActionCard(
                            title: "Generate Ideas",
                            subtitle: "AI-powered business ideas just for you",
                            icon: "sparkles",
                            color: AppColors.accent
                        ) {
                            showIdeaGenerator = true
                            HapticManager.shared.trigger(.medium)
                        }
                        .fadeInUp(delay: 0.2)
                    }
                    .padding(.horizontal, 24)
                    
                    // Recent Ideas - Only if they exist
                    if !businessPlanStore.businessIdeas.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Your Ideas")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(businessPlanStore.businessIdeas.count)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(businessPlanStore.businessIdeas.prefix(5).enumerated()), id: \.element.id) { index, idea in
                                        SimpleIdeaCard(idea: idea) {
                                            selectedIdea = idea
                                            businessPlanStore.selectedIdeaID = idea.id
                                            HapticManager.shared.trigger(.success)
                                        }
                                        .fadeInUp(delay: Double(index) * 0.1)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .fadeInUp(delay: 0.3)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.vertical, 16)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showBrainDump) {
            BrainDumpView()
                .environmentObject(businessPlanStore)
        }
        .sheet(isPresented: $showIdeaGenerator) {
            AIIdeaGeneratorView()
                .environmentObject(businessPlanStore)
        }
    }
}

// Clean, modern action card
private struct CleanActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(color.opacity(0.3))
                    .cornerRadius(14)
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Simple idea card
private struct SimpleIdeaCard: View {
    let idea: BusinessIdea
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primary)
                    
                    Spacer()
                    
                    if idea.progress > 0 {
                        Text("\(idea.progress)%")
                            .font(.caption.bold())
                            .foregroundColor(AppColors.primary)
                    }
                }
                
                Text(idea.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(idea.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(3)
                
                if idea.progress > 0 {
                    ProgressView(value: Double(idea.progress), total: 100)
                        .tint(AppColors.primary)
                }
            }
            .padding(16)
            .frame(width: 240)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    DiscoverView()
        .environmentObject(BusinessPlanStore())
}
