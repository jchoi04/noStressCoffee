//
//  OnboardingViewModel.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import Foundation
import Supabase
import Combine

struct ProfileUpdate: Encodable {
    let id: UUID
    let full_name: String
    let username: String
}

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var username = ""
    @Published var errorMessage: String? = nil
    @Published var isSaving = false
    
    func saveProfile(onSuccess: @escaping () -> Void) async {
        isSaving = true
        errorMessage = nil
        
        let cleanedUsername = username.lowercased().replacingOccurrences(of: " ", with: "")
        
        do {
            guard let user = try? await SupabaseManager.client.auth.session.user else {
                errorMessage = "Authentication error. Please log in again."
                isSaving = false
                return
            }
            
            let update = ProfileUpdate(
                id: user.id,
                full_name: fullName,
                username: cleanedUsername
            )
            
            try await SupabaseManager.client
                .from("profiles")
                .upsert(update)
                .execute()
            
            onSuccess()
            
        } catch let error as PostgrestError {
            // Postgres error code 23505 specifically means "unique_violation"
            if error.code == "23505" {
                errorMessage = "That username is already taken. Please choose another."
            } else {
                // For other database errors, show the actual message provided by Supabase
                errorMessage = "Database error: \(error.message)"
            }
        } catch {
            // Catch-all for standard network drops or Swift errors
            errorMessage = "A network error occurred. Please check your connection and try again."
        }
        
        isSaving = false
    }
}
