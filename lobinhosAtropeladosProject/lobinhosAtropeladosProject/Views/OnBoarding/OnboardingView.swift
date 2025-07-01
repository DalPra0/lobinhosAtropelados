//
//  OnboardingView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 30/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPageInfo] = [
        OnboardingPageInfo(title: "Feito para universitários", description: "Cadastre seu curso, período e tarefas. Deixa que a gente organiza do seu jeito!"),
        OnboardingPageInfo(title: "Prioridades com Inteligência", description: "Nossa IA analisa suas tarefas e define as prioridades para você, otimizando seu tempo."),
        OnboardingPageInfo(title: "Sua rotina, do seu jeito", description: "Adicione atividades, defina prioridades e visualize suas tarefas. Mais foco, menos estresse!")
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index]).tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(currentPage == index ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: currentPage == index ? 24 : 8, height: 8)
                }
            }
            .animation(.easeInOut, value: currentPage)
            .padding(.bottom, 50)

            VStack(spacing: 16) {
                Button("AVANÇAR") {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                }
                .buttonStyle(OnboardingButtonStyle(isPrimary: false))

                Button("COMEÇAR") {
                    hasCompletedOnboarding = true
                }
                .buttonStyle(OnboardingButtonStyle(isPrimary: true))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

struct OnboardingButtonStyle: ButtonStyle {
    let isPrimary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
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

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
