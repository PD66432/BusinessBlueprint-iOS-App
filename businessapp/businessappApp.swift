//
//  businessappApp.swift
//  businessapp
//
//  Created by Aadjot Singh Sidhu on 11/4/25.
//

import SwiftUI

@main
struct businessappApp: App {
    @StateObject private var authVM = AuthViewModel()
    
    init() {
        // Check login status when app launches
        AuthViewModel().checkLoginStatus()
    }
    
    var body: some Scene {
        WindowGroup {
            if authVM.isLoggedIn {
                RootView()
                    .environmentObject(authVM)
            } else {
                LaunchView()
                    .environmentObject(authVM)
            }
        }
    }
}
