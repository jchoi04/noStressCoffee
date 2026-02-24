//
//  UpdatePasswordView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/19/26.
//

import SwiftUI

struct UpdatePasswordView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var localError: String? = nil
    @State private var showingForgotPassword = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Enter your new password to secure your account.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 12) {
                    CustomPasswordField(placeholder: "New Password", text: $newPassword)
                    CustomPasswordField(placeholder: "Confirm Password", text: $confirmPassword)
                }
                
                if let error = localError ?? authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                if authVM.isTokenExpired {
                    Button(action: {
                        showingForgotPassword = true
                    }) {
                        Text("Link expired? Request a new one.")
                            .font(.footnote)
                            .foregroundColor(.brown)
                            .underline()
                    }
                    .padding(.top, 5)
                }
                
                Button(action: {
                    handlePasswordUpdate()
                }) {
                    if authVM.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Update Password")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Reset Password")
            .interactiveDismissDisabled()
        }
    }
    
    private func handlePasswordUpdate() {
        localError = nil
        
        guard newPassword == confirmPassword else {
            localError = "Passwords do not match."
            return
        }
        
        guard newPassword.count >= 8 else {
            localError = "Password must be at least 8 characters long."
            return
        }
        
        Task {
            await authVM.updatePassword(newPassword: newPassword)
        }
    }
}

#Preview {
    UpdatePasswordView()
        .environmentObject(AuthViewModel())
}
