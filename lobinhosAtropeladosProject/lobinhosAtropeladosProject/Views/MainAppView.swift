//
//  MainAppView.swift.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 27/06/25.
//

import SwiftUI

struct MainAppView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            ContentView() // já contém o TabView com TelaInicialView
        } else {
            StartView(onLogin: {
                isLoggedIn = true
            })
        }
    }
}

#Preview {
    MainAppView()
}
