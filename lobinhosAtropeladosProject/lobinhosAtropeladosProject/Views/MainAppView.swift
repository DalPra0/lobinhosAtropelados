import SwiftUI

enum AppState: String, RawRepresentable {
    case onboarding
    case cadastro
    case mainApp
}

struct MainAppView: View {
    @AppStorage("appState") private var appState: AppState = .onboarding
    // Nova variável para controlar a tela "Tudo Pronto"
    @AppStorage("viuTelaTudoPronto") private var viuTelaTudoPronto: Bool = false
    
    var body: some View {
        switch appState {
        case .onboarding:
            OnboardingView(appState: $appState)
            
        case .cadastro:
            CadastroView(appState: $appState)
            
        case .mainApp:
            // Lógica para mostrar a tela certa
            if !viuTelaTudoPronto {
                // Se o usuário ainda não viu, mostra a tela "Tudo Pronto"
                TudoProntoView(foiApresentada: $viuTelaTudoPronto)
            } else {
                // Se já viu, vai direto para o app principal
                ContentView()
            }
        }
    }
}
