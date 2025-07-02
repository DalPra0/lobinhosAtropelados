//
//  OnboardingPageView.swift
//  lobinhosAtropeladosProject
//
//  Created by Gemini on 01/07/25.
//
//  Esta View desenha uma única página do carrossel de onboarding.
//

import SwiftUI

// Struct para guardar as informações de cada página.
// Adicionamos 'imageSymbol' para o ícone.
struct OnboardingPageInfo {
    let id = UUID()
    let imageSymbol: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPageInfo

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Círculo rosa com ícone, como no seu design.
            Circle()
                .fill(Color(red: 1.0, green: 0.1, blue: 0.4))
                .frame(width: 150, height: 150)
                .shadow(color: .pink.opacity(0.3), radius: 10, y: 5)
                .overlay(
                    Image(systemName: page.imageSymbol)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(40)
                )
                .padding(.bottom, 50)

            // Textos da página, usando a fonte customizada.
            Text(page.title)
                .font(.secularOne(size: 28))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}
