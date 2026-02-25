//
//  HomeViewModel.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var timeBasedGreeting: String = "Hello"
    
    func updateGreeting(for name: String?) {
        let displayName = name?.components(separatedBy: " ").first ?? "Coffee Lover"
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:  self.timeBasedGreeting = "Good morning, \(displayName)!"
        case 12..<17: self.timeBasedGreeting = "Good afternoon, \(displayName)!"
        case 17..<20: self.timeBasedGreeting = "Good evening, \(displayName)!"
        default:      self.timeBasedGreeting = "Hello, \(displayName)!"
        }
    }
}
