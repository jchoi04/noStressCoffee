//
//  CustomTabBar.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import SwiftUI

//tab nav enum
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

//tab bar components
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

//individual tab buttons
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
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
