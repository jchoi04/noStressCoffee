//
//  AuthViewModel.swift
//  noStressCoffee
//
//  Created by James Choi on 2/13/26.
//

import Foundation
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    @Published var showVerifyEmailAlert = false
    @Published var passwordResetMessage: String? = nil
    @Published var showingUpdatePasswordSheet = false
    @Published var isTokenExpired: Bool = false
    @Published var showingForgotPasswordSheet = false
    @Published var showExpiredTokenAlert = false
    @Published var showPasswordUpdateSuccessAlert = false
    @Published var showPasswordUpdateFailedAlert = false
    
    private var authTask: Task<Void, Never>?
    init() {
        authTask = Task {
            for await (event, session) in SupabaseManager.client.auth.authStateChanges {
                print("Auth Event: \(event)")
                
                if let session = session, !session.isExpired {
                    self.currentUser = session.user
                } else {
                    self.currentUser = nil
                }
            }
        }
    }
    deinit {
        authTask?.cancel()
    }
    
    
    // Log In logic
    func logIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await SupabaseManager.client.auth.signIn(email: email, password: password)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // Sign Up logic
    func signUp(email: String, password: String) async {
        guard password.count >= 8 else {
            self.errorMessage = "Password must be at least 8 characters long."
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await SupabaseManager.client.auth.signUp(email: email, password: password)
            self.showVerifyEmailAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    //Log Off logic
    func logOff() async {
        do {
            try await SupabaseManager.client.auth.signOut()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func sendPasswordResetEmail(email: String) async {
            guard !email.isEmpty else {
                self.errorMessage = "Please enter your email to reset your password."
                return
            }
            
            isLoading = true
            errorMessage = nil
            passwordResetMessage = nil
            
            do {

                try await SupabaseManager.client.auth.resetPasswordForEmail(
                    email,
                    redirectTo: URL(string: "nostresscoffee://reset-callback")!
                )
                self.passwordResetMessage = "If an account exists, a reset link has been sent to your email."
                } catch {
                    self.errorMessage = error.localizedDescription
                }
                
                isLoading = false
        }


    func updatePassword(newPassword: String) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await SupabaseManager.client.auth.update( user: UserAttributes(password: newPassword) )
            
            self.showPasswordUpdateSuccessAlert = true
            
        } catch {
            let errorString = error.localizedDescription.lowercased()
            if errorString.contains("expired") || errorString.contains("otp_expired") || errorString.contains("403") {
                self.showPasswordUpdateFailedAlert = true
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    func handleIncomingURL(_ url: URL) {
        let urlString = url.absoluteString
        let isResetLink = urlString.contains("reset-callback")
        
        SupabaseManager.client.handle(url)
        
        guard isResetLink else { return }

        let isDeadLink = urlString.contains("error=") || urlString.contains("expired") || urlString.contains("403")
        
        Task {
            // Give SwiftUI 0.5s to settle the background screens
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if isDeadLink {
                self.showExpiredTokenAlert = true
            } else {
                self.showingUpdatePasswordSheet = true
            }
        }
    }
}
 
