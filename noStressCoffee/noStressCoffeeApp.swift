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
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
        }
    }
}
