import SwiftUI

struct MainAppView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        // Lógica limpa e correta:
        if hasCompletedOnboarding {
            // Se já passou do onboarding, vai para a tela "Começar".
            ComecarView()
        } else {
            // Se não, mostra o onboarding.
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    MainAppView()
}
