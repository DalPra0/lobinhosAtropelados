import SwiftUI

// 1. NOVO ENUM: Define os possíveis estados do fluxo inicial do app.
// Conforma com 'RawRepresentable' para ser usado com @AppStorage.
enum AppState: String, RawRepresentable {
    case onboarding
    case cadastro
    case mainApp
}

struct MainAppView: View {
    // 2. ESTADO ATUALIZADO: Usamos o novo enum com @AppStorage.
    // O estado inicial para um novo usuário será sempre '.onboarding'.
    @AppStorage("appState") private var appState: AppState = .onboarding
    
    var body: some View {
        // 3. LÓGICA ATUALIZADA: Um switch controla qual view principal é mostrada.
        switch appState {
        case .onboarding:
            // Mostra o Onboarding e passa o binding para que ele possa
            // mudar o estado para '.cadastro' ao ser concluído.
            OnboardingView(appState: $appState)
            
        case .cadastro:
            // Mostra o Cadastro e passa o binding para que ele possa
            // mudar o estado para '.mainApp' ao ser concluído.
            CadastroView(appState: $appState)
            
        case .mainApp:
            // Uma vez que tudo foi concluído, o fluxo normal do app começa.
            ComecarView()
        }
    }
}

#Preview {
    MainAppView()
}
