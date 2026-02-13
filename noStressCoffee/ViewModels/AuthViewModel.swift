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

    // Check if the user is already logged in when the app starts
    func restoreSession() async {
        do {
            let session = try await SupabaseManager.client.auth.session
            self.currentUser = session.user
        } catch {
            self.currentUser = nil
        }
    }
    
    // Log In logic
    func logIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil // Reset error state before starting
        
        // 'defer' ensures isLoading becomes false even if an error is thrown
        defer { isLoading = false }
        
        do {
            // 1. Attempt to sign in with password
            let session = try await SupabaseManager.client.auth.signIn(email: email, password: password)
            
            // 2. Update the published user property
            // This will trigger any view listening to 'currentUser' to update (e.g., navigating to Home)
            self.currentUser = session.user
            
        } catch {
            // 3. Capture the error to display in the View
            self.errorMessage = error.localizedDescription
            self.currentUser = nil
        }
    }

    // Sign Up logic
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil // Clear previous errors
        defer { isLoading = false }
        
        do {
            try await SupabaseManager.client.auth.signUp(email: email, password: password)
            // Note: Depending on Supabase settings, user might need to confirm email first
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    //Log Off
    func logOff() async {
        do {
            try await SupabaseManager.client.auth.signOut()
            self.currentUser = nil // This trigger tells the UI to swap views
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
