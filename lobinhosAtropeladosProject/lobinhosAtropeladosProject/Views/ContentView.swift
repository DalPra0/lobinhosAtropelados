//
//  ContentView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 25/06/25.
//
//  Esta é a View principal que contém a TabView.
//  Atualizada para gerenciar e passar o RitmoDiaManager.
//

import SwiftUI

struct ContentView: View {
    // Recebe o manager da MainAppView para que ele possa ser passado adiante.
    @ObservedObject var ritmoManager: RitmoDiaManager
    
    // Controla a exibição do modal de adicionar tarefa.
    @State private var showAddModal = false
    // Controla a aba selecionada na TabView.
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Aba 1: Tela Inicial de Tarefas
            TelaInicialView(ritmoManager: ritmoManager)
                .tabItem {
                    Image(systemName: "book.pages")
                    Text("Tarefas")
                }
                .tag(0)
            
            // Aba 2: Botão de Adicionar (funciona como um gatilho)
            // Este Text não é visível, serve apenas para criar a aba.
            Text("Adicionar Tarefa")
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Adicionar")
                }
                .tag(1)
            
            // Aba 3: Tela de Perfil
            PerfilView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Meu Perfil")
                }
                .tag(2)
        }
        // Define a cor dos ícones selecionados na TabView.
        .accentColor(Color("corBotaoFiltro"))
        // Apresenta o modal de adicionar tarefa quando 'showAddModal' for true.
        .sheet(isPresented: $showAddModal) {
            TarefaAddModalView()
                .presentationDetents([.large])
        }
        // Observa mudanças na aba selecionada.
        .onChange(of: selectedTab) {
            // Se o usuário tocar na aba "Adicionar" (tag 1)...
            if selectedTab == 1 {
                // ...mostra o modal...
                self.showAddModal = true
                // ...e imediatamente volta para a aba de tarefas (tag 0).
                self.selectedTab = 0
            }
        }
    }
}
