//
//  LoginView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//
//  Atualizado para usar a fonte customizada do projeto.
//

import SwiftUI

struct LoginView: View {
    // Ação a ser executada quando o login for bem-sucedido.
    var onLogin: () -> Void
    // Permite fechar a tela modal.
    @Environment(\.dismiss) var dismiss

    // Estados para guardar os dados do formulário.
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            // Cor de fundo da tela.
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                // Ícone e Títulos
                Image(systemName: "person.badge.key.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("corTextoPrimario"))
                    .padding(.bottom, 8)

                Text("Entrar")
                    .font(.secularOne(size: 28))

                Text("Entre na sua conta para continuar!")
                    .font(.body)
                    .foregroundColor(Color("corTextoSecundario"))
                    .padding(.bottom, 24)

                // Campos de Input
                VStack(spacing: 16) {
                    CustomTextBox(placeholder: "E-mail", text: $email)
                    CustomTextBox(placeholder: "Senha", text: $password, isSecure: true)
                }
                .padding(.horizontal, 32)

                Spacer()

                // Botões de Ação
                VStack(spacing: 16) {
                    // Usando o seu componente de botão customizado.
                    CustomButton(title: "Fazer login", style: .azulEscuro) {
                        // TO-DO: Adicionar lógica de autenticação aqui.
                        onLogin()
                        dismiss()
                    }
                    
                    CustomButton(title: "Voltar", style: .azulClaro) {
                        dismiss()
                    }
                }
                .padding(.horizontal)

                Spacer().frame(height: 20)
            }
            .foregroundColor(Color("corTextoPrimario"))
        }
    }
}

#Preview {
    LoginView(onLogin: {})
}
