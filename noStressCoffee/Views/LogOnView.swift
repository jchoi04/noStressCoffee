//
//  LogOnView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI

struct LogOnView: View {
    @ObservedObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("noStressCoffee")
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundColor(.brown)
            
            VStack(alignment: .leading) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            if let errorMessage = authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                if authVM.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        Task {
                            if isSignUpMode {
                                await authVM.signUp(email: email, password: password)
                            } else {
                                await authVM.logIn(email: email, password: password)
                            }
                        }
                    }) {
                        Text(isSignUpMode ? "Create Account" : "Log In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
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
            .padding(.horizontal)
        }

        .alert("Verify Email", isPresented: $authVM.showingConfirmationAlert) {
            Button("OK", role: .cancel) {
                isSignUpMode = false // Switch back to login mode after signing up
            }
        } message: {
            Text("Please check your inbox and click the verification link to activate your account.")
        }
    }
}

#Preview {
    LogOnView(authVM: AuthViewModel())
}
