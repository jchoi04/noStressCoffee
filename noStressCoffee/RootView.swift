//
//  RootView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

enum Tab {
    case home, chat, gift, announcements
}

struct RootView: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        Group {
            if authVM.currentUser == nil {
                LogOnView(authVM: authVM)
            } else {
                VStack(spacing: 0) {
                    ZStack {
                        switch selectedTab {
                        case .home: Home()
                        case .announcements: Announcements()
                        case .chat: Chat()
                        case .gift: Gift()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    HStack {
                        TabButton(image: "house", tab: .home, selected: $selectedTab)
                        Spacer()
                        TabButton(image: "megaphone", tab: .announcements, selected: $selectedTab)
                        Spacer()
                        TabButton(image: "message", tab: .chat, selected: $selectedTab)
                        Spacer()
                        TabButton(image: "gift", tab: .gift, selected: $selectedTab)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 25)
                    .padding(.bottom, 30)
                    .background(Color(.systemBackground))
                    .border(Color.gray.opacity(0.2), width: 0.5)
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
        }
        .environmentObject(authVM)
        .task {
            await authVM.restoreSession()
        }
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
}
