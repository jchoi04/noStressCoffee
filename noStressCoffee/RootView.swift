//
//  RootView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI
import Supabase

enum Tab: CaseIterable {
    case home, announcements, chat, gift, merch

    var icon: String {
        switch self {
        case .home: return "house"
        case .announcements: return "megaphone"
        case .chat: return "message"
        case .gift: return "gift"
        case .merch: return "cart"
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .home: HomeView()
        case .announcements: AnnouncementsView()
        case .chat: ChatView()
        case .gift: GiftView()
        case .merch: MerchView()
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab: Tab = .home
    
    var body: some View {
            ZStack {
                if authVM.currentUser == nil {
                    LogOnView()
                } else {
                    VStack(spacing: 0) {
                        selectedTab.destination
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        CustomTabBar(selectedTab: $selectedTab)
                    }
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
    
    
    
struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabButton(tab: tab, selected: $selectedTab)
                    
                    if tab != Tab.allCases.last {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            .background(Color(.systemBackground))
        }
    }
}

struct TabButton: View {
    let tab: Tab
    @Binding var selected: Tab
    
    var body: some View {
        Button {
            selected = tab
        } label: {
            Image(systemName: tab.icon)
                .font(.system(size: 24))
                .foregroundColor(selected == tab ? .green : .brown)
                .frame(minWidth: 44, minHeight: 44) // Better hit target
        }
    }
}
    

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
