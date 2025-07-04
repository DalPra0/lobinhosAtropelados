//
//  CustomTextField.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .background(Color.clear)
            } else {
                TextField(placeholder, text: $text)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .background(Color.clear)
            }
        }
    }
}
