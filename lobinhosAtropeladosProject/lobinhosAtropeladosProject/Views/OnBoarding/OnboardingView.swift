import SwiftUI

struct OnboardingView: View {
    @Binding var appState: AppState
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPageInfo] = [
        OnboardingPageInfo(image: "gimoMascoteOnBoarding2", title: "Bem-vindo ao Gimo!", description: "Defina sua energia para o dia e a gente te mostra por onde começar. Mais foco, menos estresse.")
        /*OnboardingPageInfo(image: "gimoMascoteOnBoarding1", title: "Bem-vindo ao Gimo!", description: "Organize suas tarefas da faculdade, e nunca mais perca prazos."),
        OnboardingPageInfo(image: "gimoMascoteOnBoarding2", title: "Feito para universitários", description: "Cadastre seu curso, período e tarefas. Deixa que a gente organiza!"),
        OnboardingPageInfo(image: "gimoMascoteOnBoarding3", title: "Sua rotina, do seu jeito", description: "Defina prioridades e visualize tarefas. Mais foco, menos estresse.")*/
    ]

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 65) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index]).tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 400)

                VStack(spacing: 24) {
                    /*
                    HStack(spacing: 8) {
                        ForEach(pages.indices, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color("corPrimaria") : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .animation(.easeInOut, value: currentPage)
                     */

                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation { currentPage += 1 }
                        } else {
                            appState = .cadastro
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "VAMOS LÁ!" : "PRÓXIMO")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("corPrimaria"))
                            .foregroundColor(Color("corFundo"))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 64)
        }
    }
}

#Preview {
    OnboardingView(appState: .constant(.onboarding))
}
