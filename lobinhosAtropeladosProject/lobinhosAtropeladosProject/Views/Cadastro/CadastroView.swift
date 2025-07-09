import SwiftUI

struct CadastroView: View {
    @Binding var appState: AppState
    
    @ObservedObject private var userModel = UserModel.shared
    
    @State private var nome: String = ""
    @State private var curso: String = ""
    @State private var periodo: String = ""
    @State private var estiloOrganizacao: String = ""
    
    @State private var currentPage = 0
    
    private let modoMapping: [String: Int] = [
        "Um dia **tranquilo**, com poucas tarefas.":1,
        "Um dia **moderado**, que seja produtivo mas sem exageros.":2,
        "Um dia **intenso**. Quero aproveitar para realizar muitas atividades.":3
    ]
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack(spacing: 8) {
                    ForEach(0..<2) { index in
                        Circle()
                            .fill(currentPage == index ? Color("corPrimaria") : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top)
                .animation(.easeInOut, value: currentPage)
                
                TabView(selection: $currentPage) {
                    CadastroStep1View(nome: $nome, curso: $curso, periodo: $periodo)
                        .tag(0)
                    
                    CadastroStep2View(estiloOrganizacao: $estiloOrganizacao)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Button(action: proximaPagina) {
                    Text(currentPage == 1 ? "FINALIZAR CADASTRO" : "PRÓXIMO")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isButtonDisabled ? Color.gray.opacity(0.5) : Color("corPrimaria"))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .disabled(isButtonDisabled)
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
    }
    
    private var isButtonDisabled: Bool {
        if currentPage == 0 {
            return nome.trimmingCharacters(in: .whitespaces).isEmpty ||
                   curso.trimmingCharacters(in: .whitespaces).isEmpty ||
                   periodo.trimmingCharacters(in: .whitespaces).isEmpty
        } else {
            return estiloOrganizacao.isEmpty
        }
    }
    
    private func proximaPagina() {
        if currentPage == 0 {
            hideKeyboard()
            withAnimation { currentPage = 1 }
        } else {
            guard let modo = modoMapping[estiloOrganizacao] else { return }
            userModel.atualizarUsuario(nome: nome, bio: "", curso: curso, periodo: periodo)
            userModel.atualizarEstiloOrganizacao(estilo: estiloOrganizacao)
            userModel.atualizar_modo(modo: modo)
            
            appState = .mainApp
        }
    }
}
