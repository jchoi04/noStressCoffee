//
//  GiftView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/6/26.
//

import SwiftUI

struct GiftView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Send a Coffee")
                    .font(.headline)
                
                Text("Surprise a friend with a digital gift card.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            .navigationTitle("Gifts")
        }
    }
}

#Preview {
    GiftView()
}
