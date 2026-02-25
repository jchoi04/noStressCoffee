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
                        

                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.brown.opacity(0.1))
                            .frame(height: 200)
                            .overlay(
                                VStack {
                                    Image(systemName: "cup.and.saucer.fill")
                                        .font(.largeTitle)
                                    Text("Featured Brew")
                                        .font(.headline)
                                }
                                .foregroundColor(.brown)
                            )
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

