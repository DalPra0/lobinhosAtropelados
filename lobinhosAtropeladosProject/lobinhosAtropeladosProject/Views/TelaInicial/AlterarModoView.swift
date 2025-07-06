import SwiftUI

struct AlterarModoView: View {
    @ObservedObject var userModel = UserModel.shared
    @ObservedObject var tarefaModel = TarefaModel.shared // Adicionado para chamar a IA
    @Environment(\.dismiss) var dismiss

    @State private var estiloSelecionado: String

    private let opcoes: [String: Int] = [
        "Poucas tarefas e um dia tranquilo.": 1,
        "Algumas tarefas, mas sem sobrecarregar meu dia.": 2,
        "Ser produtivo, mas ter pausas para um descanso.": 2, // Também é moderado
        "Foco total, quero finalizar minhas tarefas o mais rápido possível.": 3
    ]

    init() {
        _estiloSelecionado = State(initialValue: UserModel.shared.user.estiloOrganizacao ?? "")
    }

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("corTextoSecundario"))
                            .font(.title3)
                    }
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 20)

                CadastroStep2View(estiloOrganizacao: $estiloSelecionado)

                Spacer()

                Button(action: salvarAlteracao) {
                    Text("SALVAR RITMO")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(estiloSelecionado.isEmpty ? Color.gray.opacity(0.5) : Color("corPrimaria"))
                        .foregroundColor(Color("corFundo"))
                        .cornerRadius(16)
                }
                .disabled(estiloSelecionado.isEmpty)
                .padding()
            }
        }
    }

    private func salvarAlteracao() {
        // Salva as novas preferências do usuário
        userModel.atualizarEstiloOrganizacao(estilo: estiloSelecionado)
        if let modo = opcoes[estiloSelecionado] {
            userModel.atualizar_modo(modo: modo)
        }
        
        // AQUI ESTÁ A MUDANÇA: Força a IA a gerar um novo plano com base no novo modo.
        tarefaModel.chamarIA(paraGerarPlanoCompleto: true)
        
        // Fecha a tela
        dismiss()
    }
}
