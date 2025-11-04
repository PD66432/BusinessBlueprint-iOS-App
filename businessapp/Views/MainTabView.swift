import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Home/Dashboard Tab
                DashboardView()
                    .tag(0)
                    .tabItem {
                        Label("Dashboard", systemImage: "chart.bar.fill")
                    }
                
                // Business Ideas Tab
                BusinessIdeasView()
                    .tag(1)
                    .tabItem {
                        Label("Ideas", systemImage: "lightbulb.fill")
                    }
                
                // Profile Tab
                ProfileView()
                    .tag(2)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .tint(Color(red: 1, green: 0.6, blue: 0.2))
        }
    }
}

#Preview {
    MainTabView()
}
