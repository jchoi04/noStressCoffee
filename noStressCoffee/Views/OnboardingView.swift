//
//  OnboardingView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/24/26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isProfileComplete: Bool?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to noStressCoffee")
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundColor(.brown)
            
            Text("Let's get your profile set up")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                TextField("Full Name (e.g. No Stress)", text: $viewModel.fullName)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .textInputAutocapitalization(.words)
                
                TextField("Username (e.g. Coffee)", text: $viewModel.username)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button {
                Task {
                    await viewModel.saveProfile {
                        isProfileComplete = true
                    }
                }
            } label: {
                if viewModel.isSaving {
                    ProgressView().tint(.white)
                } else {
                    Text("Finish Setup")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.fullName.isEmpty || viewModel.username.isEmpty ? Color.gray : Color.brown)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.fullName.isEmpty || viewModel.username.isEmpty || viewModel.isSaving)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(isProfileComplete: .constant(false))
}
