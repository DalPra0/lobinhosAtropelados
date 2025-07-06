import SwiftUI

struct CustomTextBox: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isEditable: Bool = true

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
            } else {
                TextEditor(text: $text)
                    .padding(8)
                    .disabled(!isEditable)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isEditable ? Color("corPrimaria") : Color.clear, lineWidth: 1)
                    )
            }
        }
        .background(.clear)
        .cornerRadius(12)
        .font(.body)
        .foregroundColor(.black)
    }
}

#Preview {
    PerfilView()
}
