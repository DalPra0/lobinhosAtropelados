import SwiftUI

struct AlterarModoView: View {
    @ObservedObject var userModel = UserModel.shared
    @ObservedObject var tarefaModel = TarefaModel.shared
    @Environment(\.dismiss) var dismiss

    @State private var estiloSelecionado: String
    
    private let opcoes = [
        "Um dia **tranquilo**, com poucas tarefas.",
        "Um dia **moderado**, que seja produtivo mas sem exageros.",
        "Um dia **intenso**. Quero aproveitar para realizar muitas atividades."
    ]

    init() {
        _estiloSelecionado = State(initialValue: UserModel.shared.user.estiloOrganizacao ?? "")
    }

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 32) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("corPrimaria"))
                        .font(.system(size: 22, weight: .bold))
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Alterar Modo")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("corPrimaria"))
                    
                    Text("Eu prefiro...")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("corTextoSecundario"))
                }

                VStack(spacing: 16) {
                    ForEach(opcoes, id: \.self) { opcao in
                        BotaoDeOpcao(
                            texto: opcao,
                            selecaoAtual: $estiloSelecionado
                        )
                    }
                }
                
                Spacer()

                Button(action: salvarAlteracao) {
                    Text("SALVAR")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(estiloSelecionado.isEmpty ? Color.gray.opacity(0.5) : Color("corPrimaria"))
                        .foregroundColor(Color("corFundo"))
                        .cornerRadius(16)
                }
                .disabled(estiloSelecionado.isEmpty)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
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
            "Um dia **tranquilo**, com poucas tarefas.":1,
            "Um dia **moderado**, que seja produtivo mas sem exageros.":2,
            "Um dia **intenso**. Quero aproveitar para realizar muitas atividades.":3
        ]
        return opcoes.first(where: { $0.key == estilo })?.value
    }
}

private struct BotaoDeOpcao: View {
    let texto: String
    @Binding var selecaoAtual: String
    
    var isSelected: Bool {
        texto == selecaoAtual
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selecaoAtual = texto
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundColor(Color("corPrimaria"))
                
                Text((try! AttributedString(markdown: texto)))
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("corCardPrincipal"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color("corPrimaria") : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .foregroundColor(.black)
        .background(Color("corFundoTarefa"))
        .cornerRadius(12)
    }
}


struct AlterarModoView_Previews: PreviewProvider {
    static var previews: some View {
        AlterarModoView()
    }
}
