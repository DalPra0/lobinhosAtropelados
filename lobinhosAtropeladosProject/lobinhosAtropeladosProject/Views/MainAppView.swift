//
//  MainAppView.swift.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct MainAppView: View {
    // @AppStorage lê e escreve um valor no UserDefaults.
    // O app vai "lembrar" que o onboarding foi feito.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // Sua lógica de login existente foi mantida.
    @State private var isLoggedIn = false

    var body: some View {
        // Se o onboarding já foi concluído, mostra o fluxo normal do app.
        if hasCompletedOnboarding {
            if isLoggedIn {
                ContentView()
            } else {
                StartView(onLogin: {
                    isLoggedIn = true
                })
            }
        // Se não, mostra a nossa nova tela de Onboarding.
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    MainAppView()
}
