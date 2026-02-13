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
            
            //error message if error occurs
            if let errorMessage = authVM.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                            if authVM.isLoading {
                                ProgressView()
                                    .padding()
                            } else {
                                // Log In Button
                                Button(action: {
                                    Task {
                                        await authVM.logIn(email: email, password: password)
                                    }
                                }) {
                                    Text("Log In")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.brown)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                //Sign Up Button
                                HStack(spacing: 4) {
                                    Text("Don't have an account?")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    
                                    Text("Sign Up")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .underline()
                                        .foregroundColor(.brown)
                                        .onTapGesture {
                                            Task { await authVM.signUp(email: email, password: password) }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
            
        }
    }
    
    struct RootView: View {
        @StateObject var authVM = AuthViewModel()
        
        var body: some View {
            Group {
                if authVM.currentUser != nil {
                    RootView() // Show your main app if logged in
                        .environmentObject(authVM)
                } else {
                    LogOnView(authVM: authVM) // Show login if not
                }
            }
            .onAppear {
                Task {
                    await authVM.restoreSession()
                }
            }
        }
    }
}

#Preview {
    LogOnView(authVM: AuthViewModel())
}
