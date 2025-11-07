import SwiftUI
import Combine

struct MainTabViewNew: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var businessPlanStore: BusinessPlanStore
    @StateObject private var experienceVM = ExperienceViewModel()
    @StateObject private var timelineVM = IslandTimelineViewModel()
    @State private var selectedTab = 0
    @State private var showingOnboarding = false
    @State private var hasLinkedTimeline = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "lightbulb.fill")
            }
            .tag(0)
            
            NavigationStack {
                TimelineFinal(timelineVM: timelineVM)
            }
            .tabItem {
                Label("Timeline", systemImage: "map.fill")
            }
            .tag(1)
            
            NavigationStack {
                PlannerNotesView(timelineVM: timelineVM)
            }
            .tabItem {
                Label("Notes", systemImage: "doc.text.fill")
            }
            .tag(2)
            
            NavigationStack {
                EnhancedCoachView(timelineVM: timelineVM)
            }
            .tabItem {
                Label("AI Coach", systemImage: "sparkles")
            }
            .tag(3)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(4)
        }
        .environmentObject(experienceVM)
        .tint(AppColors.primary)
        .task(id: authVM.userId) {
            guard let userId = authVM.userId else { return }
            businessPlanStore.attachUser(userId: userId)
            experienceVM.attach(store: businessPlanStore, userId: userId)
            
            if !hasLinkedTimeline {
                timelineVM.connectToStore(businessPlanStore)
                hasLinkedTimeline = true
            }
            
            if let profile = businessPlanStore.userProfile {
                await UserContextManager.shared.initializeContext(userId: userId, profile: profile)
            }
        }
        .onAppear {
            checkOnboardingStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: .switchToPlannerTab)) { _ in
            selectedTab = 2
        }
        .onReceive(NotificationCenter.default.publisher(for: .switchToJourneyTab)) { _ in
            selectedTab = 1
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingFlow()
        }
    }
    
    private func checkOnboardingStatus() {
        if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            showingOnboarding = true
        }
    }
}
