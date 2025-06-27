//
//  StartView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct StartView: View {
    var onLogin: () -> Void

    @State private var showLogin = false
    @State private var showRegister = false

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 1.0).ignoresSafeArea()

            VStack(spacing: 8) {
                Spacer()

                Image(systemName: "timer")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.black)
                    .padding(.bottom, 16)

                Text("Seja bem-vindo!")
                    .font(.title2).bold()

                Text("Gerencie melhor seu tempo com a nossa ajuda!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.horizontal, 32)

                Spacer()

                HStack(spacing: 16) {
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
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(onLogin: onLogin)
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView(onLogin: onLogin)
        }
    }
}

#Preview {
    StartView(onLogin: {})
}

