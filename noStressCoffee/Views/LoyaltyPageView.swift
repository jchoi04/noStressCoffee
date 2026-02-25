//
//  LoyaltyPageView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

struct LoyaltyPageView: View {
    @StateObject private var userVM = UserViewModel()
    @State private var showingClaimSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let profile = userVM.currentProfile {
                        // Your existing LoyaltyCardView goes here
                        LoyaltyCardView(points: profile.points_balance ?? 0)
                        
                        // The QR Code for the barista to scan
                        if let squareId = profile.square_customer_id {
                            VStack(spacing: 8) {
                                Text("Scan at Register")
                                    .font(.headline)
                                
                                QRCodeView(customerId: squareId)
                                
                                Text("Present this code to the barista to earn points.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                        }
                    } else {
                        ProgressView()
                    }
                    
                    Button("Forgot to scan? Claim Receipt") {
                        showingClaimSheet = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.brown)
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Rewards")
            .sheet(isPresented: $showingClaimSheet) {
                ClaimPointsView()
            }
            .task {
                await userVM.fetchProfile()
            }
        }
    }
}

#Preview {
    LoyaltyPageView()
}
