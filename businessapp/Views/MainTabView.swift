import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Island Timeline Tab (Primary Dashboard)
                IslandTimelineView()
                    .tag(0)
                    .tabItem {
                        Label("Journey", systemImage: "map.fill")
                    }
                
                // Traditional Dashboard Tab
                DashboardView()
                    .tag(1)
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                
                // Business Ideas Tab
                BusinessIdeasView()
                    .tag(2)
                    .tabItem {
                        Label("Ideas", systemImage: "lightbulb.fill")
                    }
                
                // Profile Tab
                ProfileView()
                    .tag(3)
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
