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
    
    var body: some Scene {
        WindowGroup {
            if authVM.isLoggedIn {
                MainTabView()
                    .environmentObject(authVM)
            } else {
                LaunchView()
            }
        }
    }
}
