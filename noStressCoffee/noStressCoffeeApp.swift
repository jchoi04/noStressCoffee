//
//  noStressCoffeeApp.swift
//  noStressCoffee
//
//  Created by James Choi on 2/6/26.
//

import SwiftUI

@main
struct noStressCoffeeApp: App {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var userVM = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
                .environmentObject(userVM)
        }
    }
}
