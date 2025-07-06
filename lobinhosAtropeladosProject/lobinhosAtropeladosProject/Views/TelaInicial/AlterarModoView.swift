import SwiftUI

struct AlterarModoView: View {
    @ObservedObject var userModel = UserModel.shared
    @ObservedObject var tarefaModel = TarefaModel.shared
    @Environment(\.dismiss) var dismiss

    @State private var estiloSelecionado: String

    init() {
        _estiloSelecionado = State(initialValue: UserModel.shared.user.estiloOrganizacao ?? "")
    }

    var body: some View {
        NavigationView {
            VStack {
                CadastroStep2View(estiloOrganizacao: $estiloSelecionado)

                Spacer()

                Button(action: salvarAlteracao) {
                    Text("SALVAR RITMO")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(estiloSelecionado.isEmpty ? Color.gray.opacity(0.5) : Color("corPrimaria"))
                        .cornerRadius(16)
                }
                .disabled(estiloSelecionado.isEmpty)
                .padding()
            }
            .navigationTitle("Alterar seu ritmo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func salvarAlteracao() {
        userModel.atualizarEstiloOrganizacao(estilo: estiloSelecionado)
        if let modo = obterModo(para: estiloSelecionado) {
            userModel.atualizar_modo(modo: modo)
        }
        tarefaModel.chamarIA(paraGerarPlanoCompleto: true)
        dismiss()
    }

    private func obterModo(para estilo: String) -> Int? {
        let opcoes: [String: Int] = [
            "Poucas tarefas e um dia tranquilo.": 1,
            "Algumas tarefas, mas sem sobrecarregar meu dia.": 2,
            "Ser produtivo, mas ter pausas para um descanso.": 2,
            "Foco total, quero finalizar minhas tarefas o mais rápido possível.": 3
        ]
        return opcoes.first(where: { $0.key == estilo })?.value
    }
}

struct AlterarModoView_Previews: PreviewProvider {
    static var previews: some View {
        AlterarModoView()
    }
}
