//
//  UserViewModel.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import Foundation
import Supabase
import Combine

@MainActor
class UserViewModel: ObservableObject {
    @Published var currentProfile: Profile? = nil
    
    func fetchProfile() async {
        do {
            guard let user = try? await SupabaseManager.client.auth.session.user else { return }
            
            let profile: Profile = try await SupabaseManager.client
                .from("profiles")
                .select()
                .eq("id", value: user.id)
                .single()
                .execute()
                .value

            self.currentProfile = profile
            
        } catch {
            print("Error fetching profile: \(error)")
        }
    }
}

