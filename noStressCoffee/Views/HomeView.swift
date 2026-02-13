//
//  HomeView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/6/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Good morning, James")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.brown.opacity(0.1))
                            .frame(height: 200)
                            .overlay(Text("Featured Brew").foregroundColor(.brown))
                    }
                    .padding()
                }
                
                // Moved the button inside the main layout
                Button("Log Off") {
                    Task {
                        await authVM.logOff()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("noStress")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
