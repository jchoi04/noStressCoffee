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
            
            .alert("Password Updated", isPresented: $authVM.showPasswordUpdateSuccessAlert) {
                Button("OK") {
                    authVM.showingUpdatePasswordSheet = false
                }
            } message: {
                Text("Your password has been changed successfully. You are securely logged in.")
            }
            
            .alert("Password Update Failed", isPresented: $authVM.showPasswordUpdateFailedAlert) {
                Button("Cancel", role: .cancel) { }
                
                Button("Request New Link") {
                    authVM.showingUpdatePasswordSheet = false
                    
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        authVM.showingForgotPasswordSheet = true
                    }
                }
            } message: {
                Text("This password reset link has expired. Would you like to request a new one?")
            }
        }
    }
    
    private func handlePasswordUpdate() {
        localError = nil
        
        guard newPassword == confirmPassword else {
            localError = "Passwords do not match."
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
