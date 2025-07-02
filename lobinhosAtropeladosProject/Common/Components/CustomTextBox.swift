//
//  CustomTextBox.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct CustomTextBox: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
            } else {
                TextField(placeholder, text: $text)
                    .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .font(.body)
        .foregroundColor(.black)
        .autocapitalization(.none) // Adicionado para desabilitar letras maiúsculas automáticas em e-mails
        .disableAutocorrection(true) // Adicionado para desabilitar a autocorreção
    }
}
