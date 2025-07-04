//
//  CadastroView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 04/07/25.
//

import SwiftUI

struct CadastroView: View {
    // Binding para comunicar ao app que o cadastro foi concluído.
    @Binding var appState: AppState
    
    // Instância do nosso modelo de usuário para salvar os dados.
    @ObservedObject private var userModel = UserModel.shared
    
    // --- Estados para guardar os dados coletados nas 3 telas ---
    @State private var nome: String = ""
    @State private var curso: String = ""
    @State private var periodo: String = ""
    @State private var estiloOrganizacao: String = ""
    
    // Controla a página atual do carrossel.
    @State private var currentPage = 0
    
    // Controla a exibição de mensagens de erro.
    @State private var mostrarAlerta = false
    @State private var mensagemAlerta = ""
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // Carrossel de páginas
                TabView(selection: $currentPage) {
                    CadastroStep1View(nome: $nome, curso: $curso, periodo: $periodo)
                        .tag(0)
                    
                    CadastroStep2View(estiloOrganizacao: $estiloOrganizacao)
                        .tag(1)
                    
                    CadastroStep3View()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Esconde os indicadores padrão
                
                // Controles (pontos e botão)
                VStack(spacing: 24) {
                    // Indicadores de página
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color("corPrimaria") : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .animation(.easeInOut, value: currentPage)

                    // Mensagem de alerta
                    if mostrarAlerta {
                        Text(mensagemAlerta)
                            .font(.caption)
                            .foregroundColor(Color("corDestaqueAlta"))
                    }

                    // Botão de ação
                    Button(action: proximaPagina) {
                        Text(currentPage == 2 ? "VAMOS LÁ!" : "PRÓXIMO")
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
    
    // Função que controla a navegação e validação entre as telas.
    private func proximaPagina() {
        mostrarAlerta = false // Reseta o alerta
        
        switch currentPage {
        case 0:
            // Validação da primeira tela
            if nome.isEmpty || curso.isEmpty || periodo.isEmpty {
                mensagemAlerta = "Por favor, preencha todos os campos."
                mostrarAlerta = true
            } else {
                withAnimation { currentPage += 1 }
            }
        case 1:
            // Validação da segunda tela
            if estiloOrganizacao.isEmpty {
                mensagemAlerta = "Por favor, selecione uma preferência."
                mostrarAlerta = true
            } else {
                withAnimation { currentPage += 1 }
            }
        case 2:
            // Ação final: salvar tudo e ir para o app
            userModel.atualizarUsuario(nome: nome, bio: userModel.user.bio, curso: curso, periodo: periodo)
            userModel.atualizarEstiloOrganizacao(estilo: estiloOrganizacao)
            
            // Muda o estado do app para 'mainApp', concluindo o fluxo.
            appState = .mainApp
        default:
            break
        }
    }
}

#Preview {
    CadastroView(appState: .constant(.cadastro))
}
