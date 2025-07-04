//
//  CadastroView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 04/07/25.
//

import SwiftUI

struct CadastroView: View {
    @Binding var appState: AppState
    
    @ObservedObject private var userModel = UserModel.shared
    
    @State private var nome: String = ""
    @State private var curso: String = ""
    @State private var periodo: String = ""
    @State private var estiloOrganizacao: String = ""
    
    @State private var currentPage = 0
    
    @State private var mostrarAlerta = false
    @State private var mensagemAlerta = ""
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                TabView(selection: $currentPage) {
                    CadastroStep1View(nome: $nome, curso: $curso, periodo: $periodo)
                        .tag(0)
                    
                    CadastroStep2View(estiloOrganizacao: $estiloOrganizacao)
                        .tag(1)
                    
                    CadastroStep3View()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color("corPrimaria") : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .animation(.easeInOut, value: currentPage)

                    if mostrarAlerta {
                        Text(mensagemAlerta)
                            .font(.caption)
                            .foregroundColor(Color("corDestaqueAlta"))
                    }

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
    
    private func proximaPagina() {
        mostrarAlerta = false
        
        switch currentPage {
        case 0:
            if nome.isEmpty || curso.isEmpty || periodo.isEmpty {
                mensagemAlerta = "Por favor, preencha todos os campos."
                mostrarAlerta = true
            } else {
                withAnimation { currentPage += 1 }
            }
        case 1:
            if estiloOrganizacao.isEmpty {
                mensagemAlerta = "Por favor, selecione uma preferência."
                mostrarAlerta = true
            } else {
                withAnimation { currentPage += 1 }
            }
        case 2:
            userModel.atualizarUsuario(nome: nome, bio: userModel.user.bio, curso: curso, periodo: periodo)
            userModel.atualizarEstiloOrganizacao(estilo: estiloOrganizacao)
            
            appState = .mainApp
        default:
            break
        }
    }
}

#Preview {
    CadastroView(appState: .constant(.cadastro))
}
