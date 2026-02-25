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
            
            if profile.square_customer_id == nil {
                await generateSquareProfile()
            }
            
        } catch {
            print("Error fetching profile: \(error)")
        }
    }
    
    private func generateSquareProfile() async {
        do {
            try await SupabaseManager.client.functions.invoke("create-square-customer")
            await fetchProfile()
        } catch {
            print("Failed to generate Square profile: \(error)")
            if let functionError = error as? FunctionsError,
               case let .httpError(code, data) = functionError {
                let realError = String(data: data, encoding: .utf8) ?? "Unknown"
                print("Real Backend Error (\(code)): \(realError)")
            }
        }
    }
}
