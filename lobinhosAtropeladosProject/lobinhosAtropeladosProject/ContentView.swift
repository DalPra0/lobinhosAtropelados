//
//  ContentView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 25/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal = false
    @State private var selectedTab: Int = 0 // Início na primeira aba

    var body: some View {
        
        TabView(selection: $selectedTab) {
            //TelaIncialView()
            Text("Tela inicial View")
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            Text("Hello, World!")
                .tabItem {
                    Image(systemName: "plus.circle")
                }.tag(1)
            PerfilView()
                .tabItem {
                    Image(systemName: "person.circle")
                }.tag(2)
        }.accentColor(.blue)
            .sheet(isPresented: $showModal) {
                // Conteúdo da sheet
                TarefaModalView()
                    .presentationDetents([.large]) //sheet ocupe a tela inteira
            }
            .onChange(of: selectedTab) {
                if selectedTab == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.showModal = true
                        self.selectedTab = 0
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
