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
    
    private var authTask: Task<Void, Never>?
    init() {
        authTask = Task {
            for await (event, session) in SupabaseManager.client.auth.authStateChanges {
                print("Auth Event: \(event)")
                
                if let session = session, !session.isExpired {
                    self.currentUser = session.user
                    if event == .passwordRecovery {
                        self.showingUpdatePasswordSheet = true
                    }
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

    // 2. Updates the password after the user clicks the link and returns to the app
    func updatePassword(newPassword: String) async {
        guard newPassword.count >= 8 else {
            self.errorMessage = "Password must be at least 8 characters long."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await SupabaseManager.client.auth.update(
                user: UserAttributes(password: newPassword)
            )
            self.showingUpdatePasswordSheet = false
        } catch {
            let errorString = error.localizedDescription.lowercased()
            if errorString.contains("expired") || errorString.contains("otp_expired") || errorString.contains("403") {
                self.errorMessage = "This password reset link has expired or is invalid."
                self.isTokenExpired = true
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    func handleIncomingURL(_ url: URL) {
        let isResetLink = url.absoluteString.contains("reset-callback")
        
        SupabaseManager.client.handle(url)
        
        guard isResetLink else { return }
        
        Task {
            for await state in SupabaseManager.client.auth.authStateChanges {
                if state.session != nil {
                    showingUpdatePasswordSheet = true
                    break
                }
            }
        }
    }
}
