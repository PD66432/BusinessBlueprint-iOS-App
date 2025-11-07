//
//  ContentView.swift
//  businessapp
//
//  Created by Aadjot Singh Sidhu on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if authVM.isLoggedIn {
                MainTabViewNew()
            } else {
                AuthView(viewModel: authVM)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(BusinessPlanStore())
}
