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
    @Published var greeting: String = "Loading..."
    
    func fetchProfileAndGreet() async {
        do {
            guard let user = try? await SupabaseManager.client.auth.session.user else {
                self.greeting = "Hello, Coffee Lover!"
                return
            }
            
            let profile: Profile = try await SupabaseManager.client
                .from("profiles")
                .select("full_name")
                .eq("id", value: user.id)
                .single()
                .execute()
                .value

            self.greeting = getGreeting(name: profile.full_name)
            
        } catch {
            print("Error fetching profile: \(error)")
            self.greeting = "Hello, Coffee Lover!"
        }
    }

    private func getGreeting(name: String) -> String {
        let firstName = name.components(separatedBy: " ").first ?? name
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:  return "Good morning, \(firstName)!"
        case 12..<17: return "Good afternoon, \(firstName)!"
        case 17..<20: return "Good evening, \(firstName)!"
        default:      return "Hello, \(firstName)!"
        }
    }
}

