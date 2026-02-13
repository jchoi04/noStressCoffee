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
    @Published var showingConfirmationAlert = false
    
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

    // Check if the user is already logged in when the app starts
    func restoreSession() async {
        if let session = SupabaseManager.client.auth.currentSession {
            self.currentUser = session.user
        } else {
            self.currentUser = nil
        }
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
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await SupabaseManager.client.auth.signUp(email: email, password: password)
            self.showingConfirmationAlert = true
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
}
