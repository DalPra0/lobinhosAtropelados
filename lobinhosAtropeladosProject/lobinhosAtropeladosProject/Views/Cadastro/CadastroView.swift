import SwiftUI

struct CadastroView: View {
    @Binding var appState: AppState
    
    @ObservedObject private var userModel = UserModel.shared
    
    @State private var nome: String = ""
    @State private var curso: String = ""
    @State private var periodo: String = ""
    @State private var estiloOrganizacao: String = ""
    
    @State private var currentPage = 0
    
    init(appState: Binding<AppState>) {
        _appState = appState
        let user = UserModel.shared.user
        if user.periodo != ""{
            _nome = State(initialValue: user.nome)
            _curso = State(initialValue: user.curso)
            _periodo = State(initialValue: user.periodo)
            _estiloOrganizacao = State(initialValue: user.estiloOrganizacao ?? "")
        }
    }
    
    private let modoMapping: [String: Int] = [
        "Um dia **tranquilo**, com poucas tarefas.":1,
        "Um dia **moderado**, que seja produtivo mas sem exageros.":2,
        "Um dia **intenso**. Quero aproveitar para realizar muitas atividades.":3
    ]
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 24) {
                if appState == .cadastro2{
                    HStack{
                        Button{
                            appState = .cadastro1
                            guard let modo = modoMapping[estiloOrganizacao] else { return }
                            userModel.atualizar_modo(modo: modo)
                        }label:
                        {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.corPrimaria)
                                .font(.system(size: 22))
                                .bold()
                                .padding(.top,4)
                        }
                        Spacer()
                    }
                    .padding(.horizontal,24)
                }
                
                if appState == .cadastro1 {
                    CadastroStep1View(nome: $nome, curso: $curso, periodo: $periodo)
                }else{
                    CadastroStep2View(estiloOrganizacao: $estiloOrganizacao)
                }
                
                
                Button(action: proximaPagina) {
                    Text("PRÓXIMO")
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
            .padding(.bottom, 24)
            
        }
    }
    
    private var isButtonDisabled: Bool {
        if appState == .cadastro1 {
            return nome.trimmingCharacters(in: .whitespaces).isEmpty ||
                   curso.trimmingCharacters(in: .whitespaces).isEmpty ||
                   periodo.trimmingCharacters(in: .whitespaces).isEmpty
        } else {
            return estiloOrganizacao.isEmpty
        }
    }
    
    private func proximaPagina() {
        if appState == .cadastro1 {
            hideKeyboard()
            userModel.atualizarUsuario(nome: nome, bio: "", curso: curso, periodo: periodo)
            withAnimation {
            appState = .cadastro2
        }
        } else {
            guard let modo = modoMapping[estiloOrganizacao] else { return }
            userModel.atualizarEstiloOrganizacao(estilo: estiloOrganizacao)
            userModel.atualizar_modo(modo: modo)
            
            appState = .mainApp
        }
    }
}
