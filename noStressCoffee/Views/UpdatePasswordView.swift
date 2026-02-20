//
//  UpdatePasswordView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/19/26.
//

//import SwiftUI
//
//struct UpdatePasswordView: View {
//    @EnvironmentObject var authVM: AuthViewModel
//    @State private var newPassword = ""
//    @State private var showPassword = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                Text("Enter your new password to secure your account.")
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.secondary)
//                
//                passwordField
//                
//                if let error = authVM.errorMessage {
//                    Text(error).foregroundColor(.red).font(.caption)
//                }
//                
//                Button(action: {
//                    Task { await authVM.updatePassword(newPassword: newPassword) }
//                }) {
//                    if authVM.isLoading {
//                        ProgressView().tint(.white)
//                    } else {
//                        Text("Update Password")
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.brown)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Reset Password")
//            .interactiveDismissDisabled()
//        }
//    }
//    
//    var passwordField: some View {
//        ZStack(alignment: .trailing) {
//            Group {
//                if showPassword {
//                    TextField("New Password", text: $newPassword)
//                } else {
//                    SecureField("New Password", text: $newPassword)
//                }
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color(.systemGray4))
//            )
//
//            Button {
//                showPassword.toggle()
//            } label: {
//                Image(systemName: showPassword ? "eye.slash" : "eye")
//                    .foregroundColor(.gray)
//            }
//            .padding(.trailing, 12)
//        }
//    }
//}
//    
//    
//
//
//#Preview {
//    UpdatePasswordView()
//        .environmentObject(AuthViewModel())
//}
