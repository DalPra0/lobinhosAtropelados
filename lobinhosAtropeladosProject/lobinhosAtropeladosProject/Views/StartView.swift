//
//  StartView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//
//  Atualizado para usar as cores e fontes do design do projeto.
//

import SwiftUI

struct StartView: View {
    // Ação a ser executada quando o login for bem-sucedido.
    var onLogin: () -> Void

    // Controla a exibição das telas de login e cadastro.
    @State private var showLogin = false
    @State private var showRegister = false

    var body: some View {
        ZStack {
            // Usa a cor de fundo principal do app.
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                // Ícone e Títulos
                Image(systemName: "sparkles") // Ícone mais amigável
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color("corDestaqueMedia"))
                    .padding(.bottom, 16)

                Text("Seja bem-vindo!")
                    .font(.secularOne(size: 32))

                Text("Gerencie melhor seu tempo com a nossa ajuda!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("corTextoSecundario"))
                    .padding(.horizontal, 32)

                Spacer()

                // Botões de Ação
                VStack(spacing: 16) {
                    CustomButton(title: "Fazer login", style: .azulClaro) {
                        showLogin = true
                    }
                    CustomButton(title: "Cadastrar", style: .azulEscuro) {
                        showRegister = true
                    }
                }
                .padding(.horizontal)

                Spacer().frame(height: 20)
            }
            .foregroundColor(Color("corTextoPrimario"))
        }
        // Apresenta a tela de Login
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(onLogin: onLogin)
        }
        // Apresenta a tela de Cadastro
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView(onLogin: onLogin)
        }
    }
}

#Preview {
    StartView(onLogin: {})
}
