//
//  ChatView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ContentUnavailableView(
                    "No Conversations Yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Start a chat with a barista or the community.")
                )
            }
            .navigationTitle("Chat")
        }
    }
}

#Preview {
    ChatView()
}
