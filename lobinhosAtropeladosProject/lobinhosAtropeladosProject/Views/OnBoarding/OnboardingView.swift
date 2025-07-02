//
//  OnboardingView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 30/06/25.
//
//  Esta é a tela principal do onboarding, que gerencia as páginas.
//

import SwiftUI

struct OnboardingView: View {
    // Binding para comunicar ao app que o onboarding foi concluído.
    @Binding var hasCompletedOnboarding: Bool
    
    // Controla a página atual (0, 1, ou 2).
    @State private var currentPage = 0
    
    // Conteúdo para cada uma das 3 páginas, agora incluindo o nome do ícone.
    private let pages: [OnboardingPageInfo] = [
        OnboardingPageInfo(imageSymbol: "graduationcap.fill", title: "Feito para universitários", description: "Cadastre seu curso, período e tarefas. Deixa que a gente organiza do seu jeito!"),
        OnboardingPageInfo(imageSymbol: "sparkles", title: "Prioridades com Inteligência", description: "Nossa IA analisa suas tarefas e define as prioridades para você, otimizando seu tempo."),
        OnboardingPageInfo(imageSymbol: "list.bullet.clipboard.fill", title: "Sua rotina, do seu jeito", description: "Adicione atividades, defina prioridades e visualize suas tarefas. Mais foco, menos estresse!")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // TabView que permite deslizar entre as páginas.
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index]).tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Esconde os indicadores padrão.

            // Nossos indicadores de página customizados.
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(currentPage == index ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: currentPage == index ? 24 : 8, height: 8)
                }
            }
            .animation(.easeInOut, value: currentPage)
            .padding(.bottom, 50)

            // Botões de ação.
            VStack(spacing: 16) {
                Button("AVANÇAR") {
                    // Se não for a última página, avança.
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Se for a última, conclui o onboarding.
                        hasCompletedOnboarding = true
                    }
                }
                .buttonStyle(OnboardingButtonStyle(isPrimary: false))

                Button("COMEÇAR") {
                    // O botão "Começar" conclui o onboarding a qualquer momento.
                    hasCompletedOnboarding = true
                }
                .buttonStyle(OnboardingButtonStyle(isPrimary: true))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

// Estilo customizado para os botões, para ficarem idênticos ao seu design.
struct OnboardingButtonStyle: ButtonStyle {
    let isPrimary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.secularOne(size: 16).weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(isPrimary ? .black : .white)
            .foregroundColor(isPrimary ? .white : .black)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isPrimary ? Color.clear : Color.black, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

// Preview para visualização no Xcode.
#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
