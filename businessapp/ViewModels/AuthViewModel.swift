import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userId: String?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func signUp(email: String, password: String) {
        isLoading = true
        FirebaseService.shared.signUpUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let uid):
                    self?.userId = uid
                    self?.isLoggedIn = true
                    UserDefaults.standard.set(uid, forKey: "userId")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        FirebaseService.shared.signInUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let uid):
                    self?.userId = uid
                    self?.isLoggedIn = true
                    UserDefaults.standard.set(uid, forKey: "userId")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        FirebaseService.shared.signOutUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = false
                    self?.userId = nil
                    UserDefaults.standard.removeObject(forKey: "userId")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func checkLoginStatus() {
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            self.userId = savedUserId
            self.isLoggedIn = true
        }
    }
}
