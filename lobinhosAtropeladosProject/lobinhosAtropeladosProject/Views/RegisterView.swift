//
//  RegisterView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//
//  Atualizado para usar a fonte e cores customizadas do projeto.
//

import SwiftUI

struct RegisterView: View {
    var onLogin: () -> Void
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            // Usa a cor de fundo principal
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                // Ícone e Títulos
                Image(systemName: "person.badge.plus.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("corTextoPrimario"))
                    .padding(.bottom, 8)

                Text("Cadastrar")
                    .font(.secularOne(size: 28))

                Text("Crie sua conta para começar!")
                    .font(.body)
                    .foregroundColor(Color("corTextoSecundario"))
                    .padding(.bottom, 24)

                // Campos de Input
                VStack(spacing: 16) {
                    CustomTextBox(placeholder: "Nome", text: $name)
                    CustomTextBox(placeholder: "E-mail", text: $email)
                    CustomTextBox(placeholder: "Senha", text: $password, isSecure: true)
                }
                .padding(.horizontal, 32)

                Spacer()

                // Botões de Ação
                VStack(spacing: 16) {
                    CustomButton(title: "Cadastrar", style: .azulEscuro) {
                        // TO-DO: Adicionar lógica de registro aqui.
                        onLogin()
                        dismiss()
                    }
                    
                    CustomButton(title: "Já tenho conta", style: .azulClaro) {
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
    RegisterView(onLogin: {})
}
