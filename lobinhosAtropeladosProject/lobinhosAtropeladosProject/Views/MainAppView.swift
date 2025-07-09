import SwiftUI

enum AppState: String, RawRepresentable {
    case onboarding
    case cadastro
    case mainApp
}

struct MainAppView: View {
    @State private var isAppLoading: Bool = true
    
    @AppStorage("appState", store: AppGroup.userDefaults) private var appState: AppState = .onboarding
    @AppStorage("viuTelaTudoPronto", store: AppGroup.userDefaults) private var viuTelaTudoPronto: Bool = false
    
    var body: some View {
        if isAppLoading {
            CarregamentoView(isActive: $isAppLoading)
        } else {
            Group {
                switch appState {
                case .onboarding:
                    OnboardingView(appState: $appState)
                
                case .cadastro:
                    CadastroView(appState: $appState)
                
                case .mainApp:
                    if !viuTelaTudoPronto {
                        TudoProntoView(foiApresentada: $viuTelaTudoPronto)
                    } else {
                        ContentView()
                    }
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
