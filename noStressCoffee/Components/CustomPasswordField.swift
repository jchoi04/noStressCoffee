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
    
    enum Field {
        case secure, plain
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack(alignment: .trailing) {
        
            ZStack(alignment: .leading) {
                SecureField(placeholder, text: $text)
                    .focused($focusedField, equals: .secure)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .opacity(showPassword ? 0 : 1)
                
                TextField(placeholder, text: $text)
                    .focused($focusedField, equals: .plain)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .opacity(showPassword ? 1 : 0)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 6)
                .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .frame(height: 50)
            
            Button(action: {
                let wasFocused = (focusedField != nil)
                showPassword.toggle()
                
                if wasFocused {
                    focusedField = showPassword ? .plain : .secure
                }
            }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .padding(.trailing, 12)
            }
        }
    }
}

#Preview {
    CustomPasswordField(placeholder: "Password", text: .constant(""))
}
