import SwiftUI

enum CustomButtonStyle {
    case disabledButton
    case strokeButton
    case filledButton
}

struct CustomButton: View {
    let title: String
    let style: CustomButtonStyle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(Color("corPrimaria")), lineWidth: 1)
                )
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .disabledButton:
            return Color(.systemGray5)
        case .strokeButton:
            return Color(.clear)
        case .filledButton:
            return Color("corPrimaria")
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .disabledButton:
            return .gray
        case .strokeButton:
            return Color("corPrimaria")
        case .filledButton:
            return Color(.white)
        }
    }
}

#Preview {
    PerfilView()
}
