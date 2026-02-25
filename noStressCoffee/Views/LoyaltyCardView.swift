//
//  LoyaltyCardView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import SwiftUI

struct LoyaltyCardView: View {
    var points: Int
    
    // Example logic: 100 points = a reward
    var progress: Double {
        return min(Double(points) / 100.0, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("noStress Rewards")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(points) pts")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.brown)
                }
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .font(.system(size: 40))
                    .foregroundColor(points >= 100 ? .yellow : .gray.opacity(0.3))
            }
            
            VStack(spacing: 8) {
                ProgressView(value: progress)
                    .tint(.brown)
                    .background(Color.brown.opacity(0.2))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                HStack {
                    Text(points >= 100 ? "Reward unlocked!" : "\(100 - points) points to next reward")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("100 pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    LoyaltyCardView(points: 0)
}
