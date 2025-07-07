import SwiftUI

struct PerfilView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userModel = UserModel.shared
    @ObservedObject var tarefaModel = TarefaModel.shared

    @State private var curso: String
    @State private var periodo: String
    
    // Estados originais para detectar mudanças
    private let cursoOriginal: String
    private let periodoOriginal: String

    init() {
        let cursoInicial = UserModel.shared.user.curso
        let periodoInicial = UserModel.shared.user.periodo
        
        _curso = State(initialValue: cursoInicial)
        _periodo = State(initialValue: periodoInicial)
        
        self.cursoOriginal = cursoInicial
        self.periodoOriginal = periodoInicial
    }
    
    // Propriedade computada para verificar se houve alterações
    private var houveMudancas: Bool {
        return curso != cursoOriginal || periodo != periodoOriginal
    }

    private var tarefasConcluidasCount: Int {
        tarefaModel.tarefas.filter { $0.concluida }.count
    }

    private var modoPreferido: String {
        switch userModel.user.modo_selecionado {
        case 1:
            return "Tranquilo"
        case 3:
            return "Intenso"
        default:
            return "Moderado"
        }
    }
    
    // Propriedade para retornar a cor correta do modo
    private var corDoModo: Color {
        switch userModel.user.modo_selecionado {
        case 1:
            return Color("corModoTranquilo")
        case 3:
            return Color("corModoIntenso")
        default:
            return Color("corModoModerado")
        }
    }

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.corPrimaria)
                                .font(.system(size: 22))
                                .bold()
                        }
                        Spacer()
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meu perfil")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corTextoSecundario"))

                        Text(userModel.user.nome)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color("corPrimaria"))
                    }

                    VStack(spacing: 24) {
                        campoDeEdicao(titulo: "Eu curso:", placeholder: "Design de Produto", texto: $curso)
                        campoDeEdicao(titulo: "E estou no:", placeholder: "4 Período", texto: $periodo)
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Resumo de Atividades")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))

                        VStack(spacing: 12) {
                            tarefasConcluidasCard()
                            modoPreferidoCard()
                        }
                    }

                    Spacer(minLength: 16)

                    if houveMudancas {
                        Button(action: salvarAlteracoes) {
                            Text("SALVAR")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color("corPrimaria"))
                                .foregroundColor(Color("corFundo"))
                                .cornerRadius(12)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeInOut, value: houveMudancas)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarHidden(true)
    }

    private func salvarAlteracoes() {
        userModel.atualizarUsuario(
            nome: userModel.user.nome,
            bio: userModel.user.bio,
            curso: curso,
            periodo: periodo
        )
        dismiss()
    }

    // --- CARD DE TAREFAS CONCLUÍDAS (VERSÃO CORRIGIDA) ---
    @ViewBuilder
    private func tarefasConcluidasCard() -> some View {
        HStack(spacing: 16) {
            //GeometryReader { geometry in
                ZStack {
                    Image("gimoMascotePerfil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 132, height: 132) // Aumentando o mascote
                    
                    // --- CORREÇÃO: Posição e estilo do número ---
                    Text("\(tarefasConcluidasCount)")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("corPrimaria"))
                        .offset(y: 15) // Ajuste fino para posicionar na placa
                }
                .frame(width: 132) // Container do ZStack
           // }
            
            Text("Tarefas\nConcluídas") // Usando \n para quebra de linha
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color("corTextoSecundario")) // Corrigindo a cor do texto
                .lineSpacing(4)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 112) // Altura mínima para acomodar o conteúdo
        .background(Color("corCardPerfil"))
        .cornerRadius(12)
        // --- CORREÇÃO: Removido o overlay da borda ---
    }

    // --- CARD DE MODO PREFERIDO (VERSÃO CORRIGIDA) ---
    @ViewBuilder
    private func modoPreferidoCard() -> some View {
        HStack(spacing: 10) {
            Text("Modo\nPreferido")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color("corTextoSecundario"))
                .lineSpacing(4)
            
            Spacer()
            
            Text(modoPreferido)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(corDoModo)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 73)
        .background(Color("corCardPerfil"))
        .cornerRadius(12)
        // --- CORREÇÃO: Removido o overlay da borda ---
    }

    // --- CAMPO DE EDIÇÃO (VERSÃO CORRIGIDA) ---
    @ViewBuilder
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titulo)
                    .font(.system(size: 14))
                    .foregroundColor(Color("corTextoSecundario"))
                Spacer()
                // --- CORREÇÃO: Botão "Editar" adicionado ---
                Button("Editar") {
                    // Ação para editar
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("corPrimaria"))
            }

            TextField(placeholder, text: texto)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("corTextoSecundario"))
                .padding(.horizontal, 16)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color("corCardPrincipal"))
                .cornerRadius(12)
                // --- CORREÇÃO: Removido o overlay da borda ---
        }
    }
}

#Preview {
    PerfilView()
}
