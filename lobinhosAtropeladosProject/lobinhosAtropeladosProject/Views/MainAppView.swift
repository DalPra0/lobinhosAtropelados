//
//  MainAppView.swift.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct MainAppView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    @State private var isLoggedIn = false

    var body: some View {
        if hasCompletedOnboarding {
            if isLoggedIn {
                ContentView()
            } else {
                TelaInicialView()
            }
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    MainAppView()
}
