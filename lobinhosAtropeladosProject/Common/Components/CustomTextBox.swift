//
//  CustomTextBox.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct CustomTextBox: View {
    @Binding var text: String
    var isEditable: Bool = true

    var body: some View {
        TextEditor(text: $text)
            .frame(height: 100)
            .padding(8)
            .disabled(!isEditable)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEditable ? Color.gray.opacity(0.3) : Color.clear)
            )
    }
}
