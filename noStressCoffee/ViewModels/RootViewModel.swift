//
//  RootViewModel.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import Foundation
import Supabase
import Combine

@MainActor
class RootViewModel: ObservableObject {
    @Published var isProfileComplete: Bool? = nil
    
    func checkProfileStatus() async {
        do {
            guard let user = try? await SupabaseManager.client.auth.session.user else {
                self.isProfileComplete = false
                return
            }
            
            struct ProfileCheck: Codable { let id: UUID }
            
            let _: ProfileCheck = try await SupabaseManager.client
                .from("profiles")
                .select("id")
                .eq("id", value: user.id)
                .single()
                .execute()
                .value
            
            self.isProfileComplete = true
            
        } catch {
            print("Profile check failed (expected for new users): \(error.localizedDescription)")
            self.isProfileComplete = false
        }
    }
}
