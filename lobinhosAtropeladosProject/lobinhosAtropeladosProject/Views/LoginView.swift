//
//  LoginView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct LoginView: View {
    var onLogin: () -> Void
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 1.0).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "timer")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.black)

                Text("Entrar")
                    .font(.title2).bold()

                Text("Acesse sua conta")
                    .foregroundColor(.black.opacity(0.7))

                VStack(spacing: 12) {
                    CustomTextBox(text: $email)
                    CustomTextBox(text: $password)
                }

                .padding(.horizontal, 32)

                Spacer()

                HStack(spacing: 16) {
                    CustomButton(title: "Cadastrar", style: .azulClaro) {
                        dismiss() // volta para tela inicial
                    }

                    CustomButton(title: "Fazer login", style: .azulEscuro) {
                        onLogin()
                        dismiss()
                    }
                }
                .padding(.horizontal)

                Spacer().frame(height: 20)
            }
        }
    }
}

#Preview {
    LoginView(onLogin: {})
}
