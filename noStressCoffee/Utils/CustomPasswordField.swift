//
//  CustomPasswordField.swift
//  noStressCoffee
//
//  Created by James Choi on 2/20/26.
//

import SwiftUI

struct CustomPasswordField: View {
    var placeholder: String
    @Binding var text: String
    @State private var showPassword = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .trailing){
                Group {
                    if showPassword {
                        TextField(placeholder, text: $text)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } else {
                        SecureField(placeholder, text: $text)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .frame(height: 50)
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
            }
        }
        //took out padding horizontal b/c parent stack already has horizontal padding
    }
}


#Preview {
    CustomPasswordField(placeholder: "password here", text: .init(get: {""}, set: {_ in}))
}
