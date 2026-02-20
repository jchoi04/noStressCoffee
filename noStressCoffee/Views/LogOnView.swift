//
//  LogOnView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

struct LogOnView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUpMode = false
    @State private var localError: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            headerSection
            inputSection
            errorSection
            actionSection
        }
        .padding(.horizontal)
//        .alert("Password Reset", isPresented: Binding(
//                get: { authVM.passwordResetMessage != nil },
//                set: { _ in authVM.passwordResetMessage = nil }
//            )) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                if let message = authVM.passwordResetMessage {
//                    Text(message)
//                }
//            }
        .alert("Verify Email", isPresented: $authVM.showVerifyEmailAlert) {
            Button("OK", role: .cancel) {
                isSignUpMode = false
            }
        } message: {
            Text("Please check your inbox and click the verification link to activate your account.")
        }
    }
}

// MARK: - UI Components
private extension LogOnView {
    
    var headerSection: some View {
        Text("noStressCoffee")
            .font(.system(size: 32, weight: .bold, design: .serif))
            .foregroundColor(.brown)
    }
    
    var inputSection: some View {
        VStack(spacing: 8) {
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
            
            CustomPasswordField(placeholder: "Password", text: $password)
            if isSignUpMode {
                CustomPasswordField(placeholder: "Confirm Password", text: $confirmPassword)
            }
        }
    }
    
    @ViewBuilder
        var errorSection: some View {
            if let errorMessage = localError ?? authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    
    var actionSection: some View {
        VStack(spacing: 12) {
            if authVM.isLoading {
                ProgressView()
            } else {
                submitButton
//              forgotPassword
                modeToggleView
            }
        }
    }
    
    var submitButton: some View {
        Button(action: handleAuthAction) {
            Text(isSignUpMode ? "Create Account" : "Log In")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
//    @ViewBuilder
//    var forgotPassword: some View {
//        if !isSignUpMode {
//            Button("Forgot Password?") {
//                Task {
//                    await authVM.sendPasswordResetEmail(email: email)
//                }
//            }
//            .font(.footnote)
//            .foregroundColor(.brown)
//            .padding(.bottom, 4)
//        }
//    }
//    
    var modeToggleView: some View {
        HStack(spacing: 4) {
            Text(isSignUpMode ? "Already have an account?" : "Don't have an account?")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Text(isSignUpMode ? "Log In" : "Sign Up")
                .font(.footnote)
                .fontWeight(.bold)
                .underline()
                .foregroundColor(.brown)
                .onTapGesture {
                    withAnimation {
                        isSignUpMode.toggle()
                    }
                }
        }
    }
}

// MARK: - Actions
private extension LogOnView {
    func handleAuthAction() {
        localError = nil
        
        if isSignUpMode {
            guard password == confirmPassword else {
                localError = "Passwords do not match."
                return
            }
            Task { await authVM.signUp(email: email, password: password) }
        } else {
            Task { await authVM.logIn(email: email, password: password) }
        }
    }
}

#Preview {
    LogOnView().environmentObject(AuthViewModel())
}
