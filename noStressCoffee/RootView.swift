//
//  RootView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var rootVM = RootViewModel()
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack {
            if authVM.currentUser == nil {
                LogOnView()
            } else if rootVM.isProfileComplete == false {
                OnboardingView(isProfileComplete: $rootVM.isProfileComplete)
            } else if rootVM.isProfileComplete == true {
                mainAppView
            } else {
                loadingView
            }
        }
        .sheet(isPresented: $authVM.showingUpdatePasswordSheet) {
            UpdatePasswordView()
        }
        .sheet(isPresented: $authVM.showingForgotPasswordSheet) {
            ForgotPasswordView()
        }
        .alert("Link Expired", isPresented: $authVM.showExpiredTokenAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Request New Link") { authVM.showingForgotPasswordSheet = true }
        } message: {
            Text("This password reset link has expired or already been used. Would you like to request a new one?")
        }
        .onOpenURL { url in authVM.handleIncomingURL(url) }
    }
}

// MARK: - Extracted UI Components
private extension RootView {
    var mainAppView: some View {
        VStack(spacing: 0) {
            selectedTab.destination
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
    
    var loadingView: some View {
        ProgressView("Setting up your account...")
            .task {
                await rootVM.checkProfileStatus()
            }
    }
}


#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
