//
//  CustomButton.swift.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

enum CustomButtonStyle {
    case cinza
    case azulClaro
    case azulEscuro
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
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .cinza:
            return Color(.systemGray5)
        case .azulClaro:
            return Color(red: 0.8, green: 0.9, blue: 1.0)
        case .azulEscuro:
            return Color.blue
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .azulEscuro:
            return .white
        case .azulClaro:
            return .blue
        case .cinza:
            return .gray
        }
    }
}
