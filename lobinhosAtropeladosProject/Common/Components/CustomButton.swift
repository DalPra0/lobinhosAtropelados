//
//  CustomButton.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//
//  Atualizado para usar a fonte customizada do projeto.
//

import SwiftUI

// Enum para definir os diferentes estilos visuais do botão.
// Usado principalmente nas telas de autenticação.
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
                // Adicionada a fonte customizada para consistência.
                .font(.secularOne(size: 16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(16)
        }
    }

    // Define a cor de fundo com base no estilo.
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

    // Define a cor do texto com base no estilo.
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
