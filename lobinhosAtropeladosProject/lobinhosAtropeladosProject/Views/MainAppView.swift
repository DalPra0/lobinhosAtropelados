//
//  MainAppView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//
//  Esta é a View raiz que controla o fluxo inicial do app.
//  Atualizada para gerenciar a exibição da tela de Ritmo do Dia.
//

import SwiftUI

struct MainAppView: View {
    // @AppStorage lê e escreve um valor no UserDefaults.
    // O app vai "lembrar" que o onboarding foi feito.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // Controla se o usuário está logado.
    @State private var isLoggedIn = false
    
    // O manager do ritmo do dia é criado aqui e vive durante toda a sessão do app.
    @StateObject private var ritmoManager = RitmoDiaManager.shared

    var body: some View {
        ZStack {
            // Lógica principal de navegação
            if hasCompletedOnboarding {
                if isLoggedIn {
                    // Passa o manager para a ContentView principal.
                    ContentView(ritmoManager: ritmoManager)
                } else {
                    StartView(onLogin: {
                        isLoggedIn = true
                    })
                }
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        // A tela de ritmo aparece aqui, cobrindo todo o app quando necessário.
        .fullScreenCover(isPresented: $ritmoManager.mostrarTelaDeRitmo) {
            RitmoDiaView(ritmoManager: ritmoManager)
        }
    }
}

#Preview {
    MainAppView()
}
