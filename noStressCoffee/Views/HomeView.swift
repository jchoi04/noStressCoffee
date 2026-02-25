//
//  HomeView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/6/26.
//

//  HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var userVM: UserViewModel
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(homeVM.timeBasedGreeting)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        if let profile = userVM.currentProfile {
                            LoyaltyCardView(points: profile.points_balance ?? 0)
                        } else {
                            // Skeleton loading state
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(uiColor: .secondarySystemBackground))
                                .frame(height: 140)
                                .overlay(ProgressView())
                        }
                    }
                    .padding()
                }
            }
            Button("Log Off") {
                Task {
                    await authVM.logOff()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationTitle("noStress")
            .task {
                if userVM.currentProfile == nil {
                    await userVM.fetchProfile()
                }
                homeVM.updateGreeting(for: userVM.currentProfile?.full_name)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
}


//Button("Log Off") {
//    Task {
//        await authVM.logOff()
//    }
//}
//.buttonStyle(.borderedProminent)
//.padding()

