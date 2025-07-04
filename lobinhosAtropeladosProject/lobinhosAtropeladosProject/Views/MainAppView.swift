import SwiftUI

enum AppState: String, RawRepresentable {
    case onboarding
    case cadastro
    case mainApp
}

struct MainAppView: View {
    @AppStorage("appState") private var appState: AppState = .onboarding
    
    var body: some View {
        switch appState {
        case .onboarding:
            OnboardingView(appState: $appState)
            
        case .cadastro:
            CadastroView(appState: $appState)
            
        case .mainApp:
            ComecarView()
        }
    }
}

#Preview {
    MainAppView()
}
