import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showSignUp = false
    @State private var showSignIn = false
    @State private var animateHero = false
    
    private let featureCards: [FeatureCard] = [
        FeatureCard(
            icon: "sparkles",
            title: "AI Strategy Coach",
            description: "Generate investor-ready business plans tailored to your strengths in seconds."
        ),
        FeatureCard(
            icon: "chart.line.uptrend.xyaxis",
            title: "Realtime Analytics",
            description: "Track milestones, forecast revenue, and watch your traction come to life."
        ),
        FeatureCard(
            icon: "person.2.fill",
            title: "Collaborative Workflows",
            description: "Onboard co-founders, mentors, or investors with shared workspaces and live insights."
        )
    ]
    
    private var heroSubtitle: String {
        #if os(visionOS)
        "Step into your immersive business strategy studio."
        #else
        "Discover your perfect business idea powered by AI."
        #endif
    }
    
    var body: some View {
        ZStack {
            BackgroundAurora()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer(minLength: 40)
                    heroSection
                        .animation(.spring(response: 0.8, dampingFraction: 0.85, blendDuration: 0.4), value: animateHero)
                    ctaSection
                    featuresSection
                    VisionReadyBadge()
                    footerSection
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 40)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    animateHero = true
                }
            }
        }
        .sheet(isPresented: $showSignUp) {
            AuthView(viewModel: authVM, isSignUp: true)
        }
        .sheet(isPresented: $showSignIn) {
            AuthView(viewModel: authVM, isSignUp: false)
        }
    }
    
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label {
                Text("Business Blueprint")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
            } icon: {
                Image(systemName: "lightbulb.max.fill")
                    .font(.system(size: 38, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.orange)
            }
            
            Text(heroSubtitle)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
            
            HStack(spacing: 12) {
                FeaturePill(text: "AI-first", icon: "cpu")
                FeaturePill(text: "Investor Ready", icon: "briefcase.fill")
                FeaturePill(text: "Realtime", icon: "bolt.fill")
            }
            .opacity(animateHero ? 1 : 0)
            .offset(y: animateHero ? 0 : 12)
            .animation(.easeInOut(duration: 0.6).delay(0.1), value: animateHero)
        }
        .glassBackground(cornerRadius: 34, padding: 28)
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.6), Color.pink.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .blur(radius: 40)
                .offset(x: 20, y: -50)
        }
        .scaleEffect(animateHero ? 1 : 0.95)
        .opacity(animateHero ? 1 : 0)
        .offset(y: animateHero ? 0 : 24)
    }
    
    private var ctaSection: some View {
        VStack(spacing: 20) {
            Button(action: { showSignUp = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .bold))
                    Text("Create Your Blueprint")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    LinearGradient(
                        colors: [Color.orange, Color.pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.orange.opacity(0.4), radius: 22, x: 0, y: 12)
            }
            .buttonStyle(.plain)
            
            Button(action: { showSignIn = true }) {
                Text("Sign In to Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .foregroundColor(.white.opacity(0.9))
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1.2)
                    )
            }
            .buttonStyle(.plain)
            
            HStack(spacing: 12) {
                Image(systemName: "shield.checkerboard")
                    .foregroundColor(.white.opacity(0.7))
                Text("Secure Firebase authentication with encrypted sync.")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.65))
            }
        }
        .glassBackground(cornerRadius: 30, padding: 26)
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("What you will unlock")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.92))
            
            VStack(spacing: 18) {
                ForEach(featureCards) { feature in
                    FeatureRow(feature: feature)
                }
            }
        }
        .glassBackground(cornerRadius: 30, padding: 26)
    }
    
    private var footerSection: some View {
        Text("Optimized across iPhone, iPad, and Apple Glass with adaptive layouts and glass material design.")
            .font(.footnote)
            .foregroundColor(.white.opacity(0.65))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
    }
    
    private var horizontalPadding: CGFloat {
        #if os(visionOS)
        return 80
        #else
        return 24
        #endif
    }
}

private struct FeaturePill: View {
    let text: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.14), in: Capsule())
        .foregroundColor(.white)
    }
}

private struct FeatureRow: View {
    let feature: FeatureCard
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: feature.icon)
                .font(.system(size: 24, weight: .semibold))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.orange, Color.white.opacity(0.8))
                .frame(width: 44, height: 44)
                .background(Color.orange.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(feature.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                Text(feature.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
    }
}

private struct FeatureCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

private struct VisionReadyBadge: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "arkit")
                .font(.system(size: 44, weight: .semibold))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.orange, Color.white.opacity(0.8))
                .frame(width: 62, height: 62)
                .background(Color.orange.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Apple Glass Ready")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Text("Experience an immersive command center on visionOS.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer(minLength: 0)
        }
        .glassBackground(cornerRadius: 30, padding: 24)
    }
}

private struct BackgroundAurora: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.12, blue: 0.3),
                    Color(red: 0.1, green: 0.22, blue: 0.45)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Circle()
                .fill(Color.pink.opacity(0.35))
                .frame(width: 380, height: 380)
                .blur(radius: 120)
                .offset(x: -160, y: -220)
            
            Circle()
                .fill(Color.orange.opacity(0.28))
                .frame(width: 420, height: 420)
                .blur(radius: 140)
                .offset(x: 200, y: -260)
            
            Circle()
                .fill(Color.blue.opacity(0.25))
                .frame(width: 320, height: 320)
                .blur(radius: 160)
                .offset(x: -220, y: 260)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LaunchView()
        .environmentObject(AuthViewModel())
}
