//
//  RootView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

enum Tab {
    case homeview, chatview, giftview, announcementsview
}

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab: Tab = .homeview
    
    var body: some View {
        Group {
            if authVM.currentUser == nil {
                LogOnView(authVM: authVM)
            } else {
                VStack(spacing: 0) {
                    contentArea
                    tabBar
                }
            }
        }
        .task {
            await authVM.restoreSession()
        }
    }
    
    
    
    // MARK: Content Switcher
    private var contentArea: some View {
        ZStack {
            switch selectedTab {
            case .homeview: HomeView()
            case .announcementsview: AnnouncementsView()
            case .chatview: ChatView()
            case .giftview: GiftView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Navigation Bar
    private var tabBar: some View {
        HStack {
            TabButton(image: "house", tab: .homeview, selected: $selectedTab)
            Spacer()
            TabButton(image: "megaphone", tab: .announcementsview, selected: $selectedTab)
            Spacer()
            TabButton(image: "message", tab: .chatview, selected: $selectedTab)
            Spacer()
            TabButton(image: "gift", tab: .giftview, selected: $selectedTab)
        }
        .padding(.horizontal, 40)
        .padding(.top, 30)
        .padding(.bottom, 0) // Let the safe area handle the bottom spacing
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground) .ignoresSafeArea(edges: .bottom))
        .overlay(Divider(), alignment: .top)
    }
}

//sub-view for each button
struct TabButton: View {
    let image: String
    let tab: Tab
    @Binding var selected: Tab //changes selectedTab variable
    
    var body: some View {
        Button(action: { selected = tab }) {
            Image(systemName: image)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(selected == tab ? .green : .brown)
        }
    }
}
    

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
