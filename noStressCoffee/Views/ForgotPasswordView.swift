//
//  ForgotPasswordView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/20/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .frame(height: 50)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)
                
                // Displays errors like "Invalid email format"
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    Task { await authVM.sendPasswordResetEmail(email: email) }
                }) {
                    if authVM.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Send Reset Link")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.brown)
                }
            }
            
            .alert("Password Reset", isPresented: Binding(
                get: { authVM.passwordResetMessage != nil },
                set: { _ in authVM.passwordResetMessage = nil }
            )) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                if let message = authVM.passwordResetMessage {
                    Text(message)
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel())
}
