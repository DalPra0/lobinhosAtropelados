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

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 1.0).ignoresSafeArea()

            VStack {
                Spacer()

                Image(systemName: "timer")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
                    .padding(.bottom, 8)

                Text("Entrar")
                    .font(.title2).bold()

                Text("Entre na sua conta para continuar!")
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.bottom, 8)

                VStack(spacing: 12) {
                    CustomTextBox(placeholder: "E-mail", text: $email)
                    CustomTextBox(placeholder: "Senha", text: $password)
                }

                .padding(.horizontal, 32)

                Spacer()

                HStack(spacing: 16) {
                    CustomButton(title: "Cadastrar", style: .azulClaro) {
                        dismiss()
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
